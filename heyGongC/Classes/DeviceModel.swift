//
//  DeviceParam.swift
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
        let deviceName: String
    }
    
    ///control: 기기 제어하기
    struct DeviceControlRequest: Codable {
        var controlType: String
        var controlMode: String
        
        init(controlType: ControlType, controlMode: ControlMode) {
            self.controlType = controlType.rawValue
            self.controlMode = controlMode.value
        }
    }
    
    ///disconnected: 모든/하나의 기기 연동 해제
    struct DeviceDisconnectRequest: Codable {
        var deviceIds: [String]
    }
}
