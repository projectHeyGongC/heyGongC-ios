//
//  Net.swift
//  heyGongC
//
//  Created by 김은서 on 1/24/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyUserDefaults

/// kes 240129 스웨거에 있는 API
enum UserService {
    case register(param: UserParam.RegisterRequest)
    case login(param: UserParam.LoginRequest)
    case unregister
    case refreshToken(param: UserParam.TokenRequest)
    case info
    
    /**
     
     */
    var isParsing: Bool {
        switch self {
        case .register, .login, .refreshToken, .info:
            return true
        case .unregister:
            return false
        }
    }
}

extension UserService: TargetType, AccessTokenAuthorizable {
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .login, .register:
            return .none
        default:
            return .bearer
        }
    }
    
    var baseURL: URL {
        return URL(string: ServiceAPI.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .register(_):
            return "users/register"
        case .login(_):
            return "users/login"
        case .unregister:
            return "users/unregister"
        case .refreshToken:
            return "users/token/refresh"
        case .info:
            return "users/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .login, .unregister, .refreshToken:
            return .post
        case .info:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .register(param: let param):
            return .requestJSONEncodable(param)
        case .login(param: let param):
            return .requestJSONEncodable(param)
        case .unregister:
            return .requestPlain
        case .refreshToken(param: let param):
            return .requestJSONEncodable(param)
        case .info:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .register, .login, .unregister, .info:
            return ServiceAPI.shared.getHeader()
        case .refreshToken(let param):
            var header = ServiceAPI.shared.getHeader()
            header["RefreshAccessTokenRequest"] = "refreshToken,\(param)"
            
            return header
        }
    }
}

class UserAPI {
    static let shared = UserAPI()
    
    let tokenClosure: (TargetType) -> String = { _ in
        return Defaults.token?.accessToken ?? ""
    }
    
    let userProvider: MoyaProvider<UserService>
    
    private init() {
        // kes 240223 세션 만료 적용 테스트 필요
        userProvider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])

    }
    
    enum LoginResult<T> {
        case success(T)
        case register
        case error(GCError)
    }
    
    func networkingLogin<T: Codable>(userService: UserService, type: T.Type) -> Single<LoginResult<T>> {
        return Single<LoginResult<T>>.create { single in
            LottieIndicator.shared.show()
            self.userProvider.request(userService) { result in
                LottieIndicator.shared.dismiss()
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeLoginStatus(response: response, type: T.self)
                    single(.success(networkResult))
                    return
                case .failure(let error):
                    if error.response?.statusCode == 400 {
                        single(.success(.register))
                    } else {
                        single(.failure(error))
                    }
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    func networking<T: Codable>(userService: UserService, type: T.Type) -> Single<NetworkResult2<T>> {
        return Single<NetworkResult2<T>>.create { single in
            LottieIndicator.shared.show()
            self.userProvider.request(userService) { result in
                LottieIndicator.shared.dismiss()
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: T.self, isParsing: userService.isParsing)
                    single(.success(networkResult))
                    return
                case .failure(let error):
                    single(.failure(error))
                    return
                }
            }
            return Disposables.create()
        }
    }
}
