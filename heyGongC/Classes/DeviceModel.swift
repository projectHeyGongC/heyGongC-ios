//
//  DeviceModel.swift
//  heyGongC
//
//  Created by 장예지 on 2/20/24.
//

import Foundation

// MARK: - RequestData

class DeviceParam {
    
    ///subscribe: 메인 앱에서 카메라 기기 연동하기
    struct InfoRequest: Codable {
        var deviceId: String
        var deviceName: String
    }
    
    ///기기 정보 수정
    struct EditRequest: Codable {
        let name: String
    }
    
    ///settings: 기기 설정 변경하기
    struct DeviceSettingRequest: Codable {
        var sensitivity: String
        var cameraMode: String
    }
    
    ///control: 기기 제어하기
    struct ControlTypeRequest: Codable {
        var controlType: String
    }
    
    ///disconnected: 모든/하나의 기기 연동 해제
    struct DeviceIdsRequest: Codable {
        var deviceIds: [String]
    }
}

// MARK: - Model
struct DeviceModel : Codable {
    let deviceId: String
    let deviceName: String
    let battery: Int
    let temperature: Int
}
