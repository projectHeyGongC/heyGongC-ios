//
//  SplashView.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import Then
import SwiftyUserDefaults

class SplashView: UIViewController {
    
    private let bag = DisposeBag()
    
    private lazy var lblTitle = UILabel().then {
        $0.text = "test"
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkMember()
    }
    
    private func setUI() {
        view.autoAddSubview([lblTitle])
    }
    
    private func setLayout() {
        lblTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func checkMember() {
        if Defaults.AUTO_LOGIN {
            self.callLogin()
        } else {
            // kes 240226 SNS 로그인 되어있지 않은 상태
            SegueUtils.open(target: self, link: .SelectAccountTypeVC)
        }
    }
    
    private func callLogin() {
        // MARK: - callAPI
        guard let token = Defaults.TOKEN,
              let loginType = Defaults.LOGIN_TYPE else {
            SegueUtils.open(target: self, link: .SelectAccountTypeVC)
            return
        }
        
        let param = UserParam.LoginRequest(token: token)
        UserAPI.shared.networkingLogin(userService: .login(type: loginType, param: param), type: Token.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    Defaults.AUTO_LOGIN = true
                    ServiceAPI.shared.refreshToken(token: response)
                    
                default:
                    // kes 240226 에러로 자동 로그인 불가할 때 첫시작으로 랜딩
                    SegueUtils.open(target: self, link: .SelectAccountTypeVC)
                }
            }, onFailure: { owner, error in
                SegueUtils.open(target: self, link: .SelectAccountTypeVC)
                
            }).disposed(by: bag)
    }
}
