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
            "Content-Type": "application/json"
        ]
    }
    
    public func judgeStatus<T: Codable>(response: Response, type: T.Type) -> NetworkResult2<GenericResponse<T>> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: response.data) else { return .error(.errorJson) }
        
        switch response.statusCode {
        case 200..<300:
            
            if let error = GCErrorCode(rawValue: decodedData.status) {
                switch error {
                case .success:
                    return .success(decodedData)
                case .badRequest:
                    return .error(.badRequest)
                case .unauthorized:
                    return .error(.unauthorized)
                case .forbidden:
                    return .error(.forbidden)
                case .internalServerError:
                    return .error(.internalServerError)
                }
            } else {
                return .error(.notFoundCode)
            }
        default:
            print("❗️❗️❗️❗️ networkFail")
            return .error(.unKnown)
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
