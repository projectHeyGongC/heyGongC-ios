//
//  Net.swift
//  heyGongC
//
//  Created by 김은서 on 1/24/24.
//

import Foundation
import Moya


enum UserAPI {
    case googleRegister
    case googleLogin
    case appleRegister
    case appleLogin
    case unregister
    case refreshToken
    case info
}

extension UserAPI: TargetType {
    var baseURL: URL {
        let url = "http://13.125.159.97/v1/users/"
        
        switch self {
        case .googleRegister:
            return URL(string: url)!
        case .googleLogin:
            return URL(string: url)!
        case .appleRegister:
            return URL(string: url)!
        case .appleLogin:
            return URL(string: url)!
        case .unregister:
            return URL(string: url + "unregister")!
        case .refreshToken:
            return URL(string: url + "token/refresh")!
        case .info:
            return URL(string: url + "info")!
        }
    }
    
    var path: String {
        switch self {
        case .googleRegister:
            return "google/register"
        case .googleLogin:
            return "google/login"
        case .appleRegister:
            return "apple/register"
        case .appleLogin:
            return "apple/login"
        case .unregister, .refreshToken, .info:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .googleRegister, .googleLogin, .appleRegister, .appleLogin, .unregister, .refreshToken:
            return .post
        case .info:
            return .get
        }
    }
    
    var task: Moya.Task {
        
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
