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
import SwiftKeychainWrapper
import CryptoKit

class SelectAccountTypeVM: BaseVM {
    
    /**
     회원가입 화면으로 보낼 parameter
     */
    public var param: CreateAccountVM.Param?
    
    public var loginSuccess = BehaviorRelay<Bool>(value: false)
    public var goRegister = BehaviorRelay<Bool>(value: false)
    
    /// apple 로그인에 필요한 appleID 키체인에 저장
    /// - Parameter appleID: Apple 로그인 성공시 받는 user ID 정보
    public func updateAppleID(appleID: String?) {
        KeyChains.shared.APPLE_ID = appleID ?? ""
    }
    
    // MARK: - callAPI
    /// 로그인 api
    /// - Parameters:
    ///   - loginType: apple/google/kakao 로그인한 SNS 종류
    ///   - accessToken: 서버로 보낼 토큰
    public func callLogin(loginType: LoginType, accessToken: String) {
        self.param = CreateAccountVM.Param(loginType: loginType, accessToken: accessToken, refreshToken: "")
        
        let param = UserParam.LoginRequest(snsType: loginType.rawValue, accessToken: accessToken)
        
        UserAPI.shared.networkingLogin(userService: .login( param: param), type: Token.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    ServiceAPI.shared.refreshToken(token: response)
                    Defaults.loginType = loginType
                    self.loginSuccess.accept(true)
                case .register:
                    self.goRegister.accept(true)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callLogin - error")
                
            }).disposed(by: self.bag)
    }
}
