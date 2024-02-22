//
//  DeviceModel.swift
//  heyGongC
//
//  Created by 장예지 on 2/20/24.
//

import Foundation

// MARK: - RequestData

class DeviceParam {
    
    struct InfoRequest: Codable {
        let parsedDeviceSeq: Int?
        let deviceQR: String?
        let name: String?
        let type: String?
    }
    
    struct EditRequest: Codable {
        let name: String?
    }
    
    public func getData(params: InfoRequest) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceQR"] = params.deviceQR
        data["name"] = params.name
        data["type"] = params.type
        data["parsedDeviceSeq"] = params.parsedDeviceSeq
        
        return data
    }
    
    public func getData(params: EditRequest) -> Any {
        var data = String()
        data = params.name ?? ""
        return data
    }
}

// MARK: - Model
struct DeviceModel : Codable {
    let userSeq: Int?
    let type: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case userSeq, type, name
    }
}
