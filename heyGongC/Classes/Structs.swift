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
