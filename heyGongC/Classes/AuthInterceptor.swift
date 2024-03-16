//
//  AuthInterceptor.swift
//  heyGongC
//
//  Created by 김은서 on 2/23/24.
//

import Foundation
import Moya
import SwiftyUserDefaults
import Alamofire
import RxSwift

final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(ServiceAPI.shared.baseUrl) == true
                
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(Defaults.TOKEN?.accessToken ?? "", forHTTPHeaderField: "accessToken")
        urlRequest.setValue(Defaults.TOKEN?.refreshToken ?? "", forHTTPHeaderField: "refreshToken")
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, 
                response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 토큰 갱신 API 호출
        let param = UserParam.TokenRequest()
        UserAPI.shared.networking(userService: .refreshToken(param: param), type: String.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    // !!!: API 수정 이후 refresh 재갱신
//                    ServiceAPI.shared.refreshToken(token: response ?? "")
                    Defaults.TOKEN?.accessToken = response ?? ""
                    completion(.retry)
                case .error(let error):
                    completion(.doNotRetryWithError(error))
                }
            }, onFailure: { owner, error in
                completion(.doNotRetryWithError(error))
                
            }).disposed(by: DisposeBag())
    }
}
