//
//  DeviceCell.swift
//  heyGongC
//
//  Created by 김은서 on 3/7/24.
//

import Foundation
import UIKit

class DeviceCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    private var index: Int?
    
    public func updateDisplay(element: DeviceModel, index: Int) {
        lblName.text = element.name
        self.index = index
    }
}

extension DeviceCell {
    
}

// MARK: - DeviceStatus
extension DeviceCell {
    
    enum SensorStatus {
        case On
        case Off
        
        var imgNoise: UIImage {
            switch self {
            case .On:
                return UIImage(named: "ic_sensor_on")!
            case .Off:
                return UIImage(named: "ic_sensor_off")!
            }
        }
        
        var txtNoise: String {
            switch self {
            case .On:
                return "소리 감지 모드 on"
            case .Off:
                return "소리 감지 모드 off"
            }
        }
    }
    
    enum DeviceStatus {
        case On
        case Off
        
        var bgColor: UIColor {
            switch self {
            case .On:
                return GCColor.C_CC9A00
            case .Off:
                return GCColor.C_ADADAF
            }
        }
        
        var txtStatus: String {
            switch self {
            case .On:
                return "온라인 상태입니다"
            case .Off:
                return "오프라인 상태입니다"
            }
        }
        
        var isBtn: Bool {
            switch self {
            case .On:
                return false
            case .Off:
                return true
            }
        }
        
        var isImg: Bool {
            switch self {
            case .On:
                return true
            case .Off:
                return false
            }
        }
    }
}
