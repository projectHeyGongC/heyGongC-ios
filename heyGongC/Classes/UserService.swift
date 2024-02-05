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
    case register(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestRegisterData)
    case login(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestLoginData)
    case unregister
    case refreshToken(param: UserParam.RequestToken)
    case info
}

extension UserService: TargetType {
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
        return ServiceAPI.shared.getHeader()
    }
}

class UserAPI {
    static let shared = UserAPI()
    var tagProvider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
    private init() { }
    
    
    func networking<T: Codable>(userService: UserService, type: T.Type) -> Single<NetworkResult2<GenericResponse<T>>> {
        return Single<NetworkResult2<GenericResponse<T>>>.create { single in
            self.tagProvider.request(userService) { result in
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
