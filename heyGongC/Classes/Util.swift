//
//  Util.swift
//  heyGongC
//
//  Created by 김은서 on 1/30/24.
//

import Foundation
import TAKUUID

class Util {
    static func getUUID() -> String {
        TAKUUIDStorage.sharedInstance().migrate()
        let uuid = TAKUUIDStorage.sharedInstance().findOrCreate() ?? ""
        return uuid
    }
    
}
