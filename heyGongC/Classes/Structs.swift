//
//  Structs.swift
//  heyGongC
//
//  Created by 김은서 on 2/22/24.
//

import Foundation

// MARK: Token
struct Token: Codable {
    var accessToken, refreshToken: String
    
    func getToken() -> [String: String] {
        return ["accessToken": self.accessToken,
                "refreshToken": self.refreshToken]
    }
}
