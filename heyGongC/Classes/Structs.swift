//
//  Structs.swift
//  heyGongC
//
//  Created by 김은서 on 2/22/24.
//

import Foundation
import SwiftyUserDefaults

// MARK: Token
struct Token: Codable {
    var accessToken, refreshToken: String
    
    func getToken() -> [String: String] {
        return ["accessToken": self.accessToken,
                "refreshToken": self.refreshToken]
    }
}

extension Token: DefaultsSerializable {
    static var _defaults: DefaultsCodableBridge<Token> {
        return DefaultsCodableBridge<Token>()
    }
}

enum LoginType: String, DefaultsSerializable {
    case Google = "GOOGLE"
    case Kakao = "KAKAO"
    case Apple = "APPLE"
}

// MARK: - Model
struct DeviceModel : Codable {
    var deviceId: String?
    var deviceName: String?
    var modelName: String?
    var sensitivity: String?
    var cameraOrientation: String?
    var soundSensingStatus: String?
}

struct DeviceListModel: Codable, DefaultsSerializable {
    var deviceId: String
    var deviceName: String
    var battery: Int
    var temperature: Int
    var connectStatus: String
    var soundSensingStatus: String
}
