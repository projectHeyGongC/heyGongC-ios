//
//  CameraSettingVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CameraSettingVM: BaseVM {
    
    public var deviceName = BehaviorRelay<String?>(value: nil)
    
    public var deviceInfo: DeviceModel? {
        didSet {
            deviceName.accept(deviceInfo?.deviceName)
        }
    }
}
