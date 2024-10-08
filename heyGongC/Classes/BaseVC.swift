//
//  BaseVC.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import Foundation
import SnapKit
import RxSwift
import SwiftyUserDefaults
import CoreImage

@objc protocol BaseImplementation {
    @objc optional func localized()
    func initialize()
    func bind()
    func setupHandler()
}


enum NavigationType {
    case basic
    case fullScreen
    case close
}


class BaseVC: UIViewController, BaseImplementation {
    func initialize() { }
    
    func bind() { }
    
    func setupHandler() { }
    
    var loadingContainer: UIView?
    
    private let viewModel = BaseVM()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.setupNavigationBar(type: .basic)
        addTapGesture()
        
        bind()
        initialize()
        setupHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = title
    }
    
    var tab: MainTBC? {
        return self.navigationController?.viewControllers[0] as? MainTBC
    }
    
    /**
     title과 navigationType 둘 다 설정
     
     title 먼저 세팅하지 않으면 다른 화면갔다가 오면 title 날라가기에
     */
    public func setNavTitle(title: String, navType: NavigationType) {
        self.title = title
        self.setupNavigationBar(type: navType)
    }
    
    //rx사용
    public func setErrorHandler(vm: VM?) {
        guard let bag = vm?.bag else { return }
        vm?.errorHandler
            .filterNil()
            .bind { [weak self] in
                guard let self = self else { return }
                self.setErrorHandler(error: $0)
            }.disposed(by: bag)
    }
    
    private func setErrorHandler(error: Error?) {
        
        guard let e = error as? GCError else {
            // 알 수 없는 에러
            print(error?.localizedDescription ?? "")
            GCError.notFoundCode.showErrorMsg(target: self.view)
            return
        }
        
        switch e {
        case .unauthorized:
            break
//            AuthInterceptor 추가로 test 필요
            
//            self.showAlert(localized: .DLG_EXPIRED, confirm: { [weak self] in
//                print(Defaults.REFRESH_token)
//                App.shared.introType = .login
//                self?.navigationController?.backToIntro()
//            })
//                
        default:
            print("🔋🔋🔋🔋 \(error?.localizedDescription ?? "")")
            e.showErrorMsg(target: self.view)
            break
        }
    }
    
    final public func onBack(vm: VM?) {
        if let v = vm {
            print("onBack \(v)")
            v.clearBag()
        }
    }
    
    final public func setupNavigationBar(type: NavigationType) {
        switch type {
        case .basic:
            self.title = title
            self.navigationController?.isNavigationBarHidden = false
            
        case .fullScreen:
            setLeftLabel()
            self.navigationItem.hidesBackButton = true
            self.navigationController?.isNavigationBarHidden = false
            
        case .close:
            self.navigationItem.hidesBackButton = true
            self.navigationController?.isNavigationBarHidden = false
            setCloseButton()
        }
    }
    
    func refresh() {
        
    }
}

extension BaseVC {
    
    final func showLoadingWindow() {
        guard let win = UIWindow.key else { return }
        
        if let con = loadingContainer {
            let v = SpinnerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            v.center = con.center
            con.addSubview(v)
            win.addSubview(con)
            
            con.snp.makeConstraints{ m in
                m.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - Keypad 관련
extension BaseVC {
    /**
     키패드 이외의 곳 터치시 키패드 내리기
     */
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)

        // kes 231017 테이블 뷰에서 두손가락 터치만 클릭으로 인식되기에 수정
        tapGesture.cancelsTouchesInView = false
    }
    
    @objc
    private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
}

// MARK: - 네비게이션바 관련
extension BaseVC {
    
    private func setLeftLabel() {
        let titleLabel = UILabel()
        titleLabel.textColor = GCColor.C_000000
        titleLabel.text = self.title        // kes 230830 현재 타이틀을 레이블 text로 지정
        self.title = ""                     // kes 230830 보이던 타이틀은 숨겨야함
//        titleLabel.setCustomFont(customFont: .H3B)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    private func setCloseButton() {
        let btn = UIButton()
        btn.createCloseButton()
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBtn = UIBarButtonItem(customView: btn)
        closeBtn.title = ""
        self.navigationItem.leftBarButtonItem = closeBtn
    }
    
    @objc public func close() {
        if let _ = self.presentingViewController {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            return window
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

