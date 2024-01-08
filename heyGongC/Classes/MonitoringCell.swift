//
//  MonitoringCell.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import Then
import SnapKit

class MonitoringCell : UICollectionViewCell {
    
    enum MonitoringState {
        case Off
        case On
        
        var bgColor: UIColor {
            switch self {
            case .Off:
                return GCColor.C_ADADAF
            case .On:
                return GCColor.C_BF8904
            }
        }
        
        var desc: String {
            switch self {
            case .Off:
                return Localized.MONITORING_CAMERA_OFF.txt
            case .On:
                return Localized.MONITORING_CAMERA_ON.txt
            }
        }
    }
    
    enum NoiseState {
        case Off
        case On
        
        var desc: String {
            switch self {
            case .Off:
                return Localized.MONITORING_CAMERA_OFF.txt
            case .On:
                return Localized.MONITORING_CAMERA_ON.txt
            }
        }
        
        var imgIcon: UIImage {
            switch self {
            case .Off:
                return UIImage(named: "ic_sensor_off")!
            case .On:
                return UIImage(named: "ic_sensor_on")!
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(_ frame: CGRect) {
        
    }
}
