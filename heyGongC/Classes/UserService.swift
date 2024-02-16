//
//  Net.swift
//  heyGongC
//
//  Created by 김은서 on 1/24/24.
//

import Foundation
import Moya
import RxSwift

/// kes 240129 스웨거에 있는 API
enum UserService {
    case register(type: SelectAccountTypeVM.LoginType, param: UserParam.RequestRegisterData)
    case login(type: SelectAccountTypeVM.LoginType, param: UserParam.RequestLoginData)
    case unregister
    case refreshToken(param: UserParam.RequestToken)
    case info
}

extension UserService: TargetType, AccessTokenAuthorizable {
    
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
        case .register(type: let type, param: _):
            return "/\(type.rawValue)/register"
        case .login(type: let type, param: _):
            return "/\(type.rawValue)/login"
        case .unregister:
            return "/unregister"
        case .refreshToken:
            return "/token/refresh"
        case .info:
            return "/info"
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
        case .register(type: _, param: let param):
            return .requestJSONEncodable(param)
        case .login(type: _, param: let param):
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
        return UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue) ?? ""
    }
    
    let userProvider: MoyaProvider<UserService>
    
    private init() {
        userProvider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])
    }
    
    enum LoginResult<T> {
        case success(T?)
        case register
        case error(GCError)
    }
    
    func networkingLogin<T: Codable>(userService: UserService, type: T.Type) -> Single<LoginResult<T>> {
        return Single<LoginResult<T>>.create { single in
            self.userProvider.request(userService) { result in
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeLoginStatus(response: response, type: T.self)
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
    
    func networking<T: Codable>(userService: UserService, type: T.Type) -> Single<NetworkResult2<T>> {
        return Single<NetworkResult2<T>>.create { single in
            self.userProvider.request(userService) { result in
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: T.self)
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
