//
//  UserModel.swift
//  heyGongC
//
//  Created by 김은서 on 1/26/24.
//

import Foundation

struct UserModel: Codable {
    let deviceID, deviceOS, snsType, email: String?
    let alarm, ads: Bool?

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case deviceOS = "deviceOs"
        case snsType, email, alarm, ads
    }
}
