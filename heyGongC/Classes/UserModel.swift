//
//  UserModel.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation
import SwiftyUserDefaults

// MARK: - RequestData
class UserParam {
    
    struct RegisterRequest: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "IOS"
        var ads: Bool
        var snsType: String
        var accessToken: String
    }
    
    struct LoginRequest: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "IOS"
        var snsType: String
        var accessToken: String
        var fcmToken: String = Defaults.FCM_TOKEN
    }
    
    struct TokenRequest: Codable {
        var refreshToken: String = Defaults.TOKEN?.refreshToken ?? ""
    }
    
    public func getData(params: RegisterRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceId"] = params.deviceId
        data["deviceOs"] = params.deviceOs
        data["ads"] = params.ads
        data["snsType"] = params.snsType
        data["accessToken"] = params.accessToken
        
        return data
    }
    
    public func getData(params: LoginRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceId"] = params.deviceId
        data["deviceOs"] = params.deviceOs
        data["snsType"] = params.snsType
        data["accessToken"] = params.accessToken
        data["fcmToken"] = Defaults.FCM_TOKEN
        
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
