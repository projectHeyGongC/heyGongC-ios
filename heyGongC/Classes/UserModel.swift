//
//  UserModel.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation

// MARK: - RequestData
class UserParam {
    
    struct RequestRegisterData {
        var deviceID, deviceOS: String
        var ads: Bool
        var token: Token
    }
    
    struct RequestLoginData {
        var deviceID, deviceOS: String
        var ads: Bool
        var token: Token
    }
    
    struct RequestToken {
        var refreshToken: String
    }
    
    // MARK: Token
    struct Token {
        var accessToken, refreshToken: String
        
        func getToken() -> [String: String] {
            return [self.accessToken: self.refreshToken]
        }
    }
    
    public func getData(params: RequestRegisterData) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceID"] = params.deviceID
        data["deviceOS"] = params.deviceOS
        data["ads"] = params.ads
        data["token"] = params.token.getToken()
        data["deviceID"] = params.deviceID
        
        return data
    }
    
    public func getData(params: RequestLoginData) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceID"] = params.deviceID
        data["deviceOS"] = params.deviceOS
        data["token"] = params.token.getToken()
        data["deviceID"] = params.deviceID
        
        return data
    }
    
    public func getData(params: RequestToken) -> [String: Any] {
        var data = [String : Any]()
        
        data["refreshToken"] = params.refreshToken
        
        return data
    }
}

// MARK: - Model

struct UserModel: Codable {
    let deviceID, deviceOS, snsType, email: String?
    let alarm, ads: Bool?

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case deviceOS = "deviceOs"
        case snsType, email, alarm, ads
    }
}

// MARK: - UserModel
struct TokenModel: Codable {
    let accessToken, refreshToken: String?
}
