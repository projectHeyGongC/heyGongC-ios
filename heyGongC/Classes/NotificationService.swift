//
//  NotificationService.swift
//  heyGongC
//
//  Created by 김은서 on 2/22/24.
//


import Foundation
import Moya
import RxSwift
import SwiftyUserDefaults

/// kes 240129 스웨거에 있는 API
enum NotificationService {
    case getInfo(eventSeq: Int)
    case check(eventSeq: Int)
    case getList
    case add(param: NotificationParam.InfoRequest)
}

extension NotificationService: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: ServiceAPI.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getInfo(let eventSeq), .check(let eventSeq):
            return "notification/\(eventSeq)"
        case .getList, .add:
            return "notification"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInfo, .getList:
            return .get
        case .check:
            return .put
        case .add:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getInfo, .check, .getList:
            return .requestPlain
        case .add(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return ServiceAPI.shared.getHeader()
    }
}

class NotificationAPI {
    static let shared = NotificationAPI()
    
    let tokenClosure: (TargetType) -> String = { _ in
        return Defaults.ACCESS_TOKEN
    }
    
    let notiProvider: MoyaProvider<NotificationService>
    
    private init() {
        notiProvider = MoyaProvider<NotificationService>(plugins: [MoyaLoggingPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])
    }
    
    func networking<T: Codable>(notiService: NotificationService, type: T.Type, isParsing: Bool = true) -> Single<NetworkResult2<T>> {
        return Single<NetworkResult2<T>>.create { single in
            self.notiProvider.request(notiService) { result in
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: T.self, isParsing: isParsing)
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
