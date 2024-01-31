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
    
    let baseUrl = "http://13.125.159.97/v1/users"
    
    public func getHeader() -> [String: String] {
        return [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    public func judgeStatus<T: Codable>(response: Response, type: T.Type) -> NetworkResult2<GenericResponse<T>> {
        let decoder = JSONDecoder()
        print("response \(response)")
        
        switch response.statusCode {
        case 200:
            guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: response.data) else { return .error(.errorJson) }
            return .success(decodedData)
            
        case 204:
            // kes 240131 회원가입 필요
            guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: response.data) else { return .error(.errorJson) }
            return .success(decodedData)
            
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
}

struct GenericResponse<T: Codable>: Codable {
    let code: String?
    let message: String?
    let status: Int
    let data: T?
}


// NetworkResult2.swift
public enum NetworkResult2<T> {
    case success(T)
    case error(GCError)
}
