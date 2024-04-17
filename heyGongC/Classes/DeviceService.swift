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
    case editInfo(deviceId: String, param: DeviceParam.EditRequest)
    case settings(deviceId: String, param: DeviceParam.DeviceSettingRequest)
    case control(deviceId: String, param: DeviceParam.ControlTypeRequest)
    case subscribe(param: DeviceParam.InfoRequest)
    case disconnect(param: DeviceParam.DeviceIdsRequest)
    case devices
    
    var isParsing: Bool {
        switch self {
        case .settings(deviceId: _, param: _), .disconnect(param: _), .subscribe(param: _):
            return false
        default:
            return true
        }
    }
}

extension DeviceService: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: ServiceAPI.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .editInfo(deviceId: let id, param: _):
            return "devices/\(id)"
        case .settings(deviceId: let id, param: _):
            return "devices/\(id)/settings"
        case .control(deviceId: let id, param: _):
            return "devices/\(id)/control"
        case .subscribe(param: _):
            return "devices/subscribe"
        case .disconnect(param: _):
            return "devices/disconnect"
        case .devices:
            return "devices"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .editInfo(deviceId: _, param: _), .settings(deviceId: _, param: _):
            return .put
        case .control(deviceId: _, param: _), .subscribe(param: _), .disconnect(param: _):
            return .post
        case .devices:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .editInfo(deviceId: _, param: let param):
            return .requestJSONEncodable(param)
        case .settings(deviceId: _, param: let param):
            return .requestJSONEncodable(param)
        case .control(deviceId: _, param: let param):
            return .requestJSONEncodable(param)
        case .subscribe(param: let param):
            return .requestJSONEncodable(param)
        case .disconnect(param: let param):
            return .requestJSONEncodable(param)
        case .devices:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        ServiceAPI.shared.getHeader()
    }
}

class DeviceAPI {
    static let shared = DeviceAPI()
    
    let tokenClosure: (TargetType) -> String = { _ in
        return Defaults.TOKEN?.accessToken ?? ""
    }
    
    let deviceProvider: MoyaProvider<DeviceService>
    
    private init() {
        deviceProvider = MoyaProvider<DeviceService>(plugins: [MoyaLoggingPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])
    }
    
    func networking<T: Codable>(deviceService: DeviceService, type: T.Type, isParsing: Bool = true) -> Single<NetworkResult2<T>> {
        return Single<NetworkResult2<T>>.create { single in
            LottieIndicator.shared.show()
            self.deviceProvider.request(deviceService) { result in
                LottieIndicator.shared.dismiss()
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: T.self, isParsing: deviceService.isParsing)
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
