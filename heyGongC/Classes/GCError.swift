//
//  GCError.swift
//  heyGongC
//
//  Created by 김은서 on 12/27/23.
//

import Foundation
import Toast_Swift

enum GCError: Error {
    case expired
    case badRequest
    case unauthorized
    case forbidden
    case internalServerError
    case errorJson
    case notFoundCode
    case retry
}

enum GCErrorCode: String {
    case success                            = "200"
    case badRequest                         = "400"
    case unauthorized                       = "401"
    case forbidden                          = "403"
    case internalServerError                = "500"
}

extension GCError {
    
    func processError(target: UIViewController) {
        switch self {
        case .expired:
            print("expired")
        case .badRequest:
            print("badRequest")
        case .unauthorized:
            print("unauthorized")
        case .forbidden:
            print("forbidden")
        case .internalServerError:
            print("InternalServerError")
        case .retry:
            print("retry")
        case .errorJson:
            print("errorJson")
        case .notFoundCode:
            print("notFoundCode")
        }
    }
    
    func showErrorMsg(target: UIView) {
        switch self {
        default:
            print("🪫🪫🪫🪫 \(self)")
            target.makeToast(Localized.ERROR_MSG.txt)
            
            break
        }
    }
}
