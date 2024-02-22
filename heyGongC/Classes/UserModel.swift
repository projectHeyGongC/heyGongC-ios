//
//  UserModel.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation

// MARK: - RequestData
class UserParam {
    
    struct RegisterRequest: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "iOS"
        var ads: Bool
        var token: Token
    }
    
    struct LoginRequest: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "iOS"
        var token: Token
    }
    
    struct TokenRequest: Codable {
        var refreshToken: String
    }
    
    public func getData(params: RegisterRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceId"] = params.deviceId
        data["deviceOs"] = params.deviceOs
        data["ads"] = params.ads
        data["token"] = params.token.getToken()
        data["deviceId"] = params.deviceId
        
        return data
    }
    
    public func getData(params: LoginRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceId"] = params.deviceId
        data["deviceOs"] = params.deviceOs
        data["token"] = params.token.getToken()
        
        return data
    }
    
    public func getData(params: TokenRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["refreshToken"] = params.refreshToken
        
        return data
    }
}

// MARK: - UserModel

struct UserModel: Codable {
    let deviceID, deviceOS, snsType, email: String?
    let alarm, ads: Bool?

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case deviceOS = "deviceOs"
        case snsType, email, alarm, ads
    }
}

// MARK: - TokenModel
struct TokenModel: Codable {
    let accessToken, refreshToken: String?
}
