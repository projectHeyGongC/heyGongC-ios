//
//  UserModel.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation

// MARK: - RequestData
class UserParam {
    
    struct RequestRegisterData: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "iOS"
        var ads: Bool
        var token: Token
    }
    
    struct RequestLoginData: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "iOS"
        var token: Token
    }
    
    struct RequestToken: Codable {
        var refreshToken: String
    }
    
    // MARK: Token
    struct Token: Codable {
        var accessToken, refreshToken: String
        
        func getToken() -> [String: String] {
            return ["accessToken": self.accessToken,
                    "refreshToken": self.refreshToken]
        }
    }
    
    public func getData(params: RequestRegisterData) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceId"] = params.deviceId
        data["deviceOs"] = params.deviceOs
        data["ads"] = params.ads
        data["token"] = params.token.getToken()
        data["deviceId"] = params.deviceId
        
        return data
    }
    
    public func getData(params: RequestLoginData) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceId"] = params.deviceId
        data["deviceOs"] = params.deviceOs
        data["token"] = params.token.getToken()
        
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
