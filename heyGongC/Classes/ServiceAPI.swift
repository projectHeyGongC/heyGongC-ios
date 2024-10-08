//
//  ServiceAPI.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation
import Moya
import SwiftyUserDefaults

class ServiceAPI {
    static let shared = ServiceAPI()
    
    let baseUrl = "http://15.165.133.184/v1/"
    
    public func getHeader() -> [String: String] {
        return [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    public func judgeStatus<T: Codable>(response: Response, type: T.Type, isParsing: Bool) -> NetworkResult2<T> {
        let decoder = JSONDecoder()
        print("response \(response)")
        
        switch response.statusCode {
        case 200:
            if isParsing {
                guard let decodedData = try? decoder.decode(T.self, from: response.data) else { return .error(.errorJson) }
                return .success(decodedData)
            } else {
                return .success(nil)
            }
            
        case 400:
            return .error(.badRequest)
        case 401:
            return .error(.unauthorized)
        case 403:
            return .error(.forbidden)
        case 500:
            return .error(.internalServerError)
        default:
            print("❗️❗️❗️❗️ networkFail")
            return .error(.notFoundCode)
        }
    }
    
    /**
     로그인 쪽 성공 값 _ 400 성공인 로그인 API
     */
    public func judgeLoginStatus<T: Codable>(response: Response, type: T.Type) -> UserAPI.LoginResult<T> {
        let decoder = JSONDecoder()
        print("response \(response)")
        
        switch response.statusCode {
        case 200:
            guard let decodedData = try? decoder.decode(T.self, from: response.data) else { return .error(.errorJson) }
            return .success(decodedData)
        case 400:
            return .register
        case 401:
            return .error(.unauthorized)
        case 403:
            return .error(.forbidden)
        case 500:
            return .error(.internalServerError)
        default:
            print("❗️❗️❗️❗️ networkFail")
            return .error(.notFoundCode)
        }
    }
    
    public func refreshToken(token: Token) {
        Defaults.token = token
        print("💎💎💎💎 update Token")
    }
}

// NetworkResult2.swift
public enum NetworkResult2<T> {
    case success(T?)
    case error(GCError)
}

struct BaseModel: Codable {
    let code, message: String?
}
