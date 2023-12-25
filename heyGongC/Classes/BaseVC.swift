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
    
    let safeAreaBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    
    private let viewModel = BaseVM()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.setupNavigationBar(type: .basic)
        addTapGesture()
        
        bind()
        initialize()
        setupHandler()
    }
    
    var tab: MainTBC? {
        return self.tabBarController as? MainTBC
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
    
    //그냥 다 사용
    public func setErrorHandler(error: Error?) {
        
        guard let e = error as? QTError else {
            // 알 수 없는 에러
            print(error?.localizedDescription ?? "")
            QTError.notFoundCode.showErrorMsg(target: self.view)
            return
        }
        
        switch e {
        case .expired:
            self.showAlert(title: "로그인 만료", msg: "고객님의 안전한 금융거래 보호를 위해\n재 로그인 합니다.", confirmTitle: "확인", confirm: { [weak self] in
                print(Defaults.AUTH_TOKEN)
                App.shared.introType = .login
                self?.navigationController?.backToIntro()
            })
        case .unknown(_):
            e.showErrorMsg(target: self.view)
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
            setLeftLabel()
            self.navigationItem.hidesBackButton = true
            self.navigationController?.isNavigationBarHidden = false
            setRightButton()
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
        titleLabel.textColor = QTColor.C_201E33
        titleLabel.text = self.title        // kes 230830 현재 타이틀을 레이블 text로 지정
        self.title = ""                     // kes 230830 보이던 타이틀은 숨겨야함
        titleLabel.setCustomFont(customFont: .H3B)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    private func setRightButton() {
        let btn = UIButton()
        btn.createCloseButton()
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBtn = UIBarButtonItem(customView: btn)
        closeBtn.title = ""
        self.navigationItem.rightBarButtonItem = closeBtn
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
            let win = UIApplication.shared.windows.first { $0.isKeyWindow }
            if win == nil {
                return UIApplication.shared.windows.first
            } else {
                return win
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

