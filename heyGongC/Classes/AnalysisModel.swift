//
//  AnalysisModel.swift
//  heyGongC
//
//  Created by 김은서 on 4/2/24.
//

import Foundation
// MARK: - AnalysisModel
struct AnalysisModel: Codable {
    let notifications: [Notification]?
    let videos: String?
    
    // MARK: - Notification
    struct Notification: Codable {
        let deviceID, deviceName, contents: String?

        enum CodingKeys: String, CodingKey {
            case deviceID = "deviceId"
            case deviceName, contents
        }
    }
}



// MARK: - AnalysisDetailModel
struct AnalysisDetailModel: Codable {
    let deviceID, deviceName, requestAt: String?
    let alarmCount: Int?
    let graph: [Graph]?

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case deviceName, requestAt, alarmCount, graph
    }
    
    // MARK: - Graph
    struct Graph: Codable {
        let x: String?
        let y: Int?
    }
}

