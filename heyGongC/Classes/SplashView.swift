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
        switch Defaults.loginType {
        case .google:
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                
                GIDSignIn.sharedInstance.restorePreviousSignIn() { [weak self] signInResult, _ in
                    guard let self,
                          let token = signInResult?.accessToken.tokenString else { return }
                    
                    self.callAutoLogin(loginType: .google, accessToken: token)
                    
                }
            } else {
                // kes 240226 구글 로그인 되어있지 않은 상태
                SegueUtils.open(target: self, link: .SelectAccountTypeVC)
            }
        case .apple:
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: KeyChains.shared.APPLE_ID) { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                        self.callAutoLogin(loginType: .google, accessToken: Defaults.token?.accessToken ?? "")
                    default:
                        // kes 240309 연동되어 있지않는 상태
                        SegueUtils.open(target: self, link: .SelectAccountTypeVC)
                    }
                }
        case .kakao:
            break
        default:
            SegueUtils.open(target: self, link: .SelectAccountTypeVC)
        }
    }
    
    // MARK: - callAPI
    /// 로그인
    public func callAutoLogin(loginType: LoginType, accessToken: String) {
        
        // TODO: 토큰 관련 api 정리되면 필요없는 하단 변수 정리
        let param = UserParam.LoginRequest(snsType: loginType.rawValue, accessToken: accessToken)
        
        UserAPI.shared.networkingLogin(userService: .login(param: param), type: Token.self)
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
