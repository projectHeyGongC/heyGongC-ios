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


class SelectAccountTypeVM: BaseVM {
    
    /// 마케팅 동의 여부
    public var ads = false
    
    // MARK: - callAPI
    
    /// 회원가입
    public func callRegister(userData: GIDGoogleUser) {
        let token = UserParam.Token(accessToken: userData.accessToken.tokenString, refreshToken: userData.refreshToken.tokenString)
        let param = UserParam.RequestRegisterData(ads: self.ads, token: token)
        
        UserAPI.shared.networking(userService: .register(type: .Google, param: param), type: TokenModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    break
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callRegister - error")
                
            }).disposed(by: self.bag)
    }
    
    /// 로그인
    public func callLogin(userData: GIDGoogleUser) {
        let token = UserParam.Token(accessToken: userData.accessToken.tokenString, refreshToken: "")
        let param = UserParam.RequestLoginData(token: token)
        
        UserAPI.shared.networking(userService: .login(type: .Google, param: param), type: TokenModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    if response?.code == "204" {
                        self.callRegister(userData: userData)
                    } else {
                        print("로그인 성공")
                    }
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callRegister - error")
                
            }).disposed(by: self.bag)
    }
    
    private func refreshToken() {
        let param = UserParam.RequestToken(refreshToken: "")
//        UserApi.shared.networking(userApi: .refreshToken(param: param), type: <#T##(Decodable & Encodable).Protocol#>)
    }
}
