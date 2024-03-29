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
    /// 로그인
    public func callLogin(loginType: LoginType, accessToken: String) {
        self.param = CreateAccountVM.Param(loginType: loginType, accessToken: accessToken, refreshToken: "")
        
        // TODO: 토큰 관련 api 정리되면 필요없는 하단 변수 정리
        let token = Token(accessToken: accessToken, refreshToken: "")
        let param = UserParam.LoginRequest(snsType: loginType.rawValue, accessToken: accessToken)
        
        UserAPI.shared.networkingLogin(userService: .login( param: param), type: Token.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    ServiceAPI.shared.refreshToken(token: response)
                    Defaults.LOGIN_TYPE = loginType
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
    
    public func getAppleNonce() -> String {
        return sha256(randomNonceString())
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // kes 240323 apple Login 시 필요 _ 해킹 방지 nonce 값
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
