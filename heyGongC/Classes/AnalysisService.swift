//
//  AnalysisService.swift
//  heyGongC
//
//  Created by 김은서 on 4/2/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyUserDefaults

/// kes 240129 스웨거에 있는 API
enum AnalysisService {
    case getAnalysis(requestAt: String)
    case getDetail(deviceId: String, requestAt: String)
}

extension AnalysisService: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: ServiceAPI.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getAnalysis(_):
            return "analysis"
        case .getDetail(_, _):
            return "analysis/detail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAnalysis(_):
            return .get
        case .getDetail(_, _):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAnalysis(let requestAt):
            return .requestParameters(parameters: ["requestAt": requestAt], encoding: URLEncoding.queryString)
        case .getDetail(let deviceId, let requestAt):
            return .requestParameters(parameters: ["deviceId": deviceId, "requestAt": requestAt], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ServiceAPI.shared.getHeader()
    }
}

class AnalysisAPI {
    static let shared = AnalysisAPI()
    
    let tokenClosure: (TargetType) -> String = { _ in
        return Defaults.TOKEN?.accessToken ?? ""
    }
    
    let notiProvider: MoyaProvider<AnalysisService>
    
    private init() {
        notiProvider = MoyaProvider<AnalysisService>(plugins: [MoyaLoggingPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])
    }
    
    func networking<T: Codable>(analysisService: AnalysisService, type: T.Type) -> Single<NetworkResult2<T>> {
        return Single<NetworkResult2<T>>.create { single in
            LottieIndicator.shared.show()
            self.notiProvider.request(analysisService) { result in
                LottieIndicator.shared.dismiss()
                switch result {
                case .success(let response):
                    print("🥰🥰🥰 \(response)")
                    let networkResult = ServiceAPI.shared.judgeStatus(response: response, type: T.self, isParsing: true)
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
