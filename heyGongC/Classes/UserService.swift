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
enum UserAPI {
    case register(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestRegisterData)
    case login(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestLoginData)
    case unregister
    case refreshToken(param: UserParam.RequestToken)
    case info
}

extension UserAPI: TargetType {
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
            return .requestParameters(parameters: UserParam().getData(params: param), encoding: URLEncoding.default)
        case .login(type: _, param: let param):
            return .requestParameters(parameters: UserParam().getData(params: param), encoding: URLEncoding.default)
        case .unregister:
            return .requestPlain
        case .refreshToken(param: let param):
            return .requestParameters(parameters: UserParam().getData(params: param), encoding: URLEncoding.default)
        case .info:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ServiceAPI.shared.getHeader()
    }
}

class UserService {
    static let shared = UserService()
    var tagProvider = MoyaProvider<UserAPI>()
    private init() { }
    
    
    func requestRegister(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestRegisterData) -> Single<NetworkResult2<GenericResponse<TokenModel>>> {
        return Single<NetworkResult2<GenericResponse<TokenModel>>>.create { single in
            self.tagProvider.request(.register(type: type, param: param)) { result in
                switch result {
                case .success(let response):
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: TokenModel.self)
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
    
    func requestLogin(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestLoginData) -> Single<NetworkResult2<GenericResponse<TokenModel>>> {
        return Single<NetworkResult2<GenericResponse<TokenModel>>>.create { single in
            self.tagProvider.request(.login(type: type, param: param)) { result in
                switch result {
                case .success(let response):
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: TokenModel.self)
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
    
    func requestUnregister(type: SelectAccountTypeVC.LoginType) -> Single<NetworkResult2<GenericResponse<TokenModel>>> {
        return Single<NetworkResult2<GenericResponse<TokenModel>>>.create { single in
            self.tagProvider.request(.unregister) { result in
                switch result {
                case .success(let response):
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: TokenModel.self)
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
    
    func requestToken(type: SelectAccountTypeVC.LoginType, param: UserParam.RequestToken) -> Single<NetworkResult2<GenericResponse<TokenModel>>> {
        return Single<NetworkResult2<GenericResponse<TokenModel>>>.create { single in
            self.tagProvider.request(.refreshToken(param: param)) { result in
                switch result {
                case .success(let response):
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: TokenModel.self)
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
    
    
    func getInfo() -> Single<NetworkResult2<GenericResponse<UserModel>>> {
        return Single<NetworkResult2<GenericResponse<UserModel>>>.create { single in
            self.tagProvider.request(.info) { result in
                switch result {
                case .success(let response):
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: UserModel.self)
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
