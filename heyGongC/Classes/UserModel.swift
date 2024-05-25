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
        var fcmToken: String = Defaults.fcmToken
    }
    
    struct LoginRequest: Codable {
        var deviceId = Util.getUUID()
        var deviceOs = "IOS"
        var snsType: String
        var accessToken: String
        var fcmToken: String = Defaults.fcmToken
    }
    
    struct TokenRequest: Codable {
        var refreshToken: String = Defaults.token?.refreshToken ?? ""
    }
    
    struct ChangeAlarmRequest: Codable {
        var alarm: Bool = KeyChains.shared.USER_DATA?.alarm ?? true
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
        data["fcmToken"] = Defaults.fcmToken
        
        return data
    }
    
    public func getData(params: TokenRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["refreshToken"] = params.refreshToken
        
        return data
    }
    
    public func getData(params: ChangeAlarmRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["alarm"] = params.alarm
        
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
