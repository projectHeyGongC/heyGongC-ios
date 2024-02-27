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
        
        let token = Token(accessToken: accessToken, refreshToken: "")
        let param = UserParam.LoginRequest(token: token)
        
        UserAPI.shared.networkingLogin(userService: .login(type: loginType, param: param), type: Token.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    ServiceAPI.shared.refreshToken(token: response)
                    Defaults.AUTO_LOGIN = true
                    Defaults.LOGIN_TYPE = loginType
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
