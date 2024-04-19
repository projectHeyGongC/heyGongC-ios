//
//  DeviceCell.swift
//  heyGongC
//
//  Created by 김은서 on 3/7/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxGesture
import RxOptional

class DeviceCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBattery: UILabel!
    
    @IBOutlet weak var imgSensor: UIImageView!
    @IBOutlet weak var lblSoundSensitivity: UILabel!
    @IBOutlet weak var switchSoundSensitivity: UISwitch!
    @IBOutlet weak var btnSettings: UIButton!
    
    var connectStatus: DeviceStatus?
    var sensorStatus: SensorStatus? {
        didSet {
            sensor.accept(sensorStatus ?? .Off)
        }
    }
    var sensor = BehaviorRelay<SensorStatus>(value: .Off)
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }
    
    private func bind() {
        
        self.switchSoundSensitivity.rx.isOn
            .bind(onNext: { [weak self] in
                
                let sensorStatus: SensorStatus = $0 ? .On : .Off
                self?.sensor.accept(sensorStatus)
                
            }).disposed(by: bag)
        
        self.sensor.bind(onNext: { [weak self] in
            guard let self = self else { return }
            
            lblSoundSensitivity.text = $0.txtNoise
            imgSensor.image = $0.imgNoise
            
        }).disposed(by: bag)
    }
    
    public func updateDisplay(element: DeviceListModel) {
        lblName.text = element.deviceName
        lblBattery.text = String(element.battery)
    }
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
