//
//  DeviceService.swift
//  heyGongC
//
//  Created by 장예지 on 2/20/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyUserDefaults

enum DeviceService {
    case getInfo(id: Int)
    case edit(id: Int, param: DeviceParam.EditRequest)
    case delete(id: Int)
    case getList
    case add(param: DeviceParam.InfoRequest)
    case deleteAll
}

extension DeviceService: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        default:
            return .bearer
        }
    }
    
    var baseURL: URL {
        return URL(string: ServiceAPI.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getInfo(id: let seq), .edit(id: let seq, param: _), .delete(id: let seq):
            return "device/\(seq)"
        case .getList, .deleteAll, .add(param: _):
            return "device"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .add:
            return .post
        case .getInfo, .getList:
            return .get
        case .edit:
            return .put
        case .delete, .deleteAll:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .add(let param):
            return .requestJSONEncodable(param)
        case .getList, .getInfo(id: _), .delete(id: _), .deleteAll:
            return .requestPlain
        case .edit(id: _, param: let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        ServiceAPI.shared.getHeader()
    }
}

class DeviceAPI {
    static let shared = DeviceAPI()
    
    let tokenClosure: (TargetType) -> String = { _ in
        return Defaults.ACCESS_TOKEN
    }
    
    let deviceProvider: MoyaProvider<DeviceService>
    
    private init() {
        deviceProvider = MoyaProvider<DeviceService>(plugins: [MoyaLoggingPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])
    }
    
    func networking<T: Codable>(deviceService: DeviceService, type: T.Type, isParsing: Bool = true) -> Single<NetworkResult2<T>> {
        return Single<NetworkResult2<T>>.create { single in
            self.deviceProvider.request(deviceService) { result in
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
