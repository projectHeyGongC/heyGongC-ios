//
//  NotificationModel.swift
//  heyGongC
//
//  Created by 김은서 on 2/22/24.
//

import Foundation

// MARK: - RequestData

class NotificationParam {
    
    struct InfoRequest: Codable {
        let deviceSeq: Int?
        let request: Request?
        
        struct Request: Codable {
            let type, content: String?
        }
    }
    
    
    public func getData(params: InfoRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceSeq"] = params.deviceSeq
        data["request"] = params.request
        
        return data
    }
}

// MARK: - NotificationInfo
struct NotificationModel: Codable {
    let eventSeq, userSeq: Int?
    let typeEnum, content: String?
    let readStatus: Bool?
}
