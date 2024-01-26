//
//  Net.swift
//  heyGongC
//
//  Created by 김은서 on 1/24/24.
//

import Foundation
import Moya
import RxSwift


enum UserAPI {
    case register(type: SelectAccountTypeVC.LoginType)
    case login(type: SelectAccountTypeVC.LoginType)
    case unregister
    case refreshToken
    case info
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: ServiceAPI.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .register(type: let type):
            return "/\(type.rawValue)/register"
        case .login(type: let type):
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
        case .register(let type):
            let
        case .login(let type):
            <#code#>
        case .unregister:
            <#code#>
        case .refreshToken:
            <#code#>
        case .info:
            <#code#>
        }
    }
    
    var headers: [String : String]? {
        <#code#>
    }
}

class UserParam {
    
    struct RequestRegisterData {
        var deviceID, deviceOS: String
        var ads: Bool
        var token: Token
    }
    
    // MARK: Token
    struct Token {
        var accessToken, refreshToken: String
        
        func getToken() -> [String: String] {
            return [self.accessToken: self.refreshToken]
        }
    }
    
    public func getData(params: RequestRegisterData) -> AnyObject {
        var data = [String : Any]()
        
        data["deviceID"] = params.deviceID
        data["deviceOS"] = params.deviceOS
        data["ads"] = params.ads
        data["token"] = params.token.getToken()
        data["deviceID"] = params.deviceID
        
        return data as AnyObject
    }
    
}

class UserService {
    static let shared = UserService()
    var tagProvider = MoyaProvider<UserAPI>()
    private init() { }
    
    // 받은 태그를 조회하는 api.
    func getUserInfo(cardUUID: String) -> Single<NetworkResult2<GenericResponse<UserModel>>> {
        // ✅ 서버통신의 결과를 Single로 만들어서 반환하였습니다.
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
