//
//  SelectAccountTypeVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/8/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import SwiftyUserDefaults

class SelectAccountTypeVM: BaseVM {
    
    enum LoginType: String {
        case Google = "google"
        case Kakao = "kakao"
        case Apple = "apple"
    }
    
    /**
     회원가입 화면으로 보낼 parameter
     */
    public var param: CreateAccountVM.Param?
    
    public var loginSuccess = BehaviorRelay<Bool>(value: false)
    public var goRegister = BehaviorRelay<Bool>(value: false)
    
    // MARK: - callAPI
    /// 로그인
    public func callLogin(loginType: LoginType, accessToken: String) {
        self.param = CreateAccountVM.Param(loginType: loginType, accessToken: accessToken, refreshToken: "")
        
        let token = UserParam.Token(accessToken: accessToken, refreshToken: "")
        let param = UserParam.RequestLoginData(token: token)
        
        UserAPI.shared.networkingLogin(userService: .login(type: loginType, param: param), type: TokenModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    
                    Defaults.REFRESH_TOKEN = response?.refreshToken ?? ""
                    
                    ServiceAPI.shared.refreshAccessToken(token: response?.accessToken ?? "")
                    self.loginSuccess.accept(true)
                case .register:
                    self.goRegister.accept(true)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callRegister - error")
                
            }).disposed(by: self.bag)
    }
}
