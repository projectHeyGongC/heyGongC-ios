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
import GoogleSignIn
import AuthenticationServices

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
        switch Defaults.LOGIN_TYPE {
        case .Google:
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                
                GIDSignIn.sharedInstance.restorePreviousSignIn() { [weak self] signInResult, _ in
                    guard let self,
                          let token = signInResult?.accessToken.tokenString else { return }
                    
                    self.callAutoLogin(loginType: .Google, accessToken: token)
                    
                }
            } else {
                // kes 240226 구글 로그인 되어있지 않은 상태
                SegueUtils.open(target: self, link: .SelectAccountTypeVC)
            }
        case .Apple:
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: KeyChains.shared.APPLE_ID) { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                        self.callAutoLogin(loginType: .Google, accessToken: Defaults.TOKEN?.accessToken ?? "")
                    default:
                        // kes 240309 연동되어 있지않는 상태
                        SegueUtils.open(target: self, link: .SelectAccountTypeVC)
                    }
                }
        case .Kakao:
            break
        default:
            SegueUtils.open(target: self, link: .SelectAccountTypeVC)
        }
    }
    
    // MARK: - callAPI
    /// 로그인
    public func callAutoLogin(loginType: LoginType, accessToken: String) {
        let token = Token(accessToken: accessToken, refreshToken: "")
        let param = UserParam.LoginRequest(token: token)
        
        UserAPI.shared.networkingLogin(userService: .login(type: loginType, param: param), type: Token.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    ServiceAPI.shared.refreshToken(token: response)
                    SegueUtils.open(target: self, link: .MainTBC)
                    
                default:
                    // kes 240226 에러로 자동 로그인 불가할 때 첫시작으로 랜딩
                    SegueUtils.open(target: self, link: .SelectAccountTypeVC)
                }
            }, onFailure: { owner, error in
                SegueUtils.open(target: self, link: .SelectAccountTypeVC)
                
            }).disposed(by: self.bag)
    }
}
