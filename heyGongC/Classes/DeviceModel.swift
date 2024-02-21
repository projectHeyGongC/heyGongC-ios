//
//  DeviceModel.swift
//  heyGongC
//
//  Created by 장예지 on 2/20/24.
//

import Foundation

// MARK: - RequestData

class DeviceParam {
    struct RequestAppendData: Codable {
        let parsedDeviceSeq: Int?
        let deviceQR: String?
        let name: String?
        let type: String?
    }
    
    struct RequestEditData: Codable {
        let name: String?
    }
    
    public func getData(params: RequestAppendData) -> [String: Any] {
        var data = [String : Any]()
        
        data["deviceQR"] = params.deviceQR
        data["name"] = params.name
        data["type"] = params.type
        data["parsedDeviceSeq"] = params.parsedDeviceSeq
        
        return data
    }
    
    public func getData(params: RequestEditData) -> [String: Any] {
        var data = [String : Any]()
        data["name"] = params.name
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
