//
//  KeyChains.swift
//  heyGongC
//
//  Created by 장예지 on 2/16/24.
//

import Foundation
import SwiftKeychainWrapper

extension KeychainWrapper.Key {
    static let USER_DATA: KeychainWrapper.Key = "USER_DATA"
    static let LOGIN_INFO: KeychainWrapper.Key = "LOGIN_INFO"
}

final class KeyChains {
    static let shared = KeyChains()
    private init(){ }
    
    var USER_DATA: UserModel? {
        get {
            decodeFromKeychain(forKey: .USER_DATA, as: UserModel.self)
        }
        set{
            encodeToKeychain(newValue, forKey: .USER_DATA)
        }
    }
}

// MARK: - encoding / decoding
extension KeyChains {
    private func decodeFromKeychain<T: Decodable>(forKey key: KeychainWrapper.Key, as type: T.Type) -> T? {
            let stringValue = KeychainWrapper.standard.string(forKey: key.rawValue)
            
            if let jsonData = stringValue?.data(using: .utf8) {
                let decoder = JSONDecoder()

                do {
                    let decodedData = try decoder.decode(type, from: jsonData)
                    return decodedData
                } catch {
                    print("Error decoding: \(error)")
                    return nil
                }
            } else {
                return nil
            }
        }
        
        private func encodeToKeychain<T: Encodable>(_ newValue: T?, forKey key: KeychainWrapper.Key) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            if let value = newValue {
                do {
                    let jsonData = try encoder.encode(value)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        KeychainWrapper.standard.set(jsonString, forKey: key.rawValue)
                    }
                } catch {
                    print("Error encoding: \(error)")
                }
            } else {
                // Handle the case where newValue is nil (optional is nil)
                KeychainWrapper.standard.removeObject(forKey: key.rawValue)
            }
        }

}
