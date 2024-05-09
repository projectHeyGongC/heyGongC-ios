//
//  Enums.swift
//  heyGongC
//
//  Created by 김은서 on 5/1/24.
//

import Foundation
import SwiftyUserDefaults

enum ControlType: String, Codable {
    case sensitivity = "SENSITIVITY"
    case cameraOrientation = "CAMERA_ORIENTATION"
    case soundSensing = "SOUND_SENSING"
    case stream = "STREAM"
    case camera = "CAMERA"
    case flash = "FLASH"
    case speaking = "SPEAKING"
    case lowLight = "LOW_LIGHT"
    case remoteExecution = "REMOTE_EXECUTION"
    case remoteShutDown = "REMOTE_SHUTDOWN"
}

enum ControlMode: Codable {
    case on
    case off
    case front
    case back
    case sensitivity(Sensitivity)
    
    var value: String {
        switch self {
        case .on:
            return "ON"
        case .off:
            return "OFF"
        case .front:
            return "FRONT"
        case .back:
            return "BACK"
        case .sensitivity(let mode):
            return mode.rawValue
        }
    }
    
    enum Sensitivity: String, Codable {
        case veryLow = "VERYLOW"
        case low = "LOW"
        case medium = "MEDIUM"
        case high = "HIGH"
        case veryHigh = "VERYHIGH"
        
        var sliderValue: Float {
            switch self {
            case .veryLow:
                return 0.0
            case .low:
                return 0.25
            case .medium:
                return 0.5
            case .high:
                return 0.75
            case .veryHigh:
                return 1.0
            }
        }
    }

}

enum LoginType: String, DefaultsSerializable {
    case google = "GOOGLE"
    case kakao = "KAKAO"
    case apple = "APPLE"
    
    var image: UIImage? {
        switch self {
        case .google:
            return UIImage(named: "ic_google")
        case .apple:
            return UIImage(named: "ic_apple")
        case .kakao:
            return UIImage(named: "ic_kakao")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .google:
            return .white
        case .kakao:
            guard let color = UIColor(named: "color_kakao") else { return .white }
            return color
        case .apple:
            return .black
        }
    }
}
