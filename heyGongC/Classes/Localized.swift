//
//  Localized.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//

import Foundation
import SwiftyUserDefaults

// MARK: - Localized
enum Localized {
    case ERROR_MSG
    case MONITORING_CAMERA_OFF
    case MONITORING_CAMERA_ON
    case MONITORING_NOISE_ON
    case MONITORING_NOISE_OFF

    /**
     *  다국어 처리
     */
    var txt: String {
        switch self {
        case .ERROR_MSG:
            return "잠시 후 시도해주세요"
        case .MONITORING_CAMERA_OFF:
            return "카메라가 꺼져 있습니다."
        case .MONITORING_CAMERA_ON:
            return "집 이미지를 클릭하면 모니터링이 시작됩니다."
        case .MONITORING_NOISE_ON:
            return "소리 감지 모드 on"
        case .MONITORING_NOISE_OFF:
            return "소리 감지 모드 off"
        }
    }
}

