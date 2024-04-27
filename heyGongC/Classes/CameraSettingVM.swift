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
import SwiftyUserDefaults


class CameraSettingVM: BaseVM {
    
    public var deviceInfo = BehaviorRelay<DeviceModel?>(value: nil)
    public var successDisconnected = PublishRelay<Bool>()
    public var cameraOrientationRelay = BehaviorRelay<String?>(value: nil)
    
    public func editDeviceName(name: String){
        guard let deviceId = deviceInfo.value?.deviceId else { return }
        DeviceAPI.shared.networking(deviceService: .editInfo(deviceId: deviceId, param: .init(deviceName: name)), type: DeviceModel.self)
            .subscribe(with: self,
            onSuccess: { owner, networkResult in
                switch networkResult {
                case .success:
                    if let currentInfo = self.deviceInfo.value {
                        self.deviceInfo.accept(DeviceModel(deviceId: currentInfo.deviceId,
                                                            deviceName: name,
                                                            modelName: currentInfo.modelName,
                                                            sensitivity: currentInfo.sensitivity,
                                                            cameraOrientation: currentInfo.cameraOrientation,
                                                            soundSensingStatus: currentInfo.soundSensingStatus))
                    }
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            },
            onFailure: { owner, error in
                print("error - editDeviceName")
            })
            .disposed(by: bag)
    }
    
    public func callDeviceInfo(deviceId: String){
        DeviceAPI.shared.networking(deviceService: .deviceInfo(deviceId: deviceId), type: DeviceModel.self)
            .subscribe(with: self,
             onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let deviceModel):
                    self.deviceInfo.accept(deviceModel)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            },
            onFailure: { owner, error in
                print("error - callDeviceInfo")
            })
            .disposed(by: bag)
    }
    
    public func editSensitivity(sensitivity: String?, orientation: String?){
        guard let deviceId = deviceInfo.value?.deviceId else { return }
        guard let sensitivity = sensitivity, let orientation = orientation else { return }
        let request = DeviceParam.DeviceSettingRequest(sensitivity: sensitivity, cameraOrientation: orientation)
        DeviceAPI.shared.networking(deviceService: .settings(deviceId: deviceId, param: request), type: DeviceModel.self)
            .subscribe(with: self, 
             onSuccess: { owner, networkResult in
                switch networkResult{
                case .success:
                    if let currentInfo = self.deviceInfo.value {
                        self.deviceInfo.accept(DeviceModel(deviceId: currentInfo.deviceId,
                                                           deviceName: currentInfo.deviceName,
                                                            modelName: currentInfo.modelName,
                                                            sensitivity: sensitivity,
                                                            cameraOrientation: orientation,
                                                            soundSensingStatus: currentInfo.soundSensingStatus))
                    }
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            },
            onFailure: { owner, error in
                print("error - editSensitivity")
            })
            .disposed(by: bag)
    }
    
    public func deviceDisconnect(){
        
        guard let deviceId = deviceInfo.value?.deviceId else { return }
        let disconnectDevice = DeviceParam.DeviceDisconnectRequest(deviceIds: [deviceId])
        DeviceAPI.shared.networking(deviceService: .disconnect(param: disconnectDevice), type: DeviceModel.self)
            .subscribe(with: self, 
             onSuccess: { owner, networkResult in
                switch networkResult {
                case .success:
                    self.successDisconnected.accept(true)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            },
            onFailure: { owner, error in
                print("deviceDisconnect - error")
            })
            .disposed(by: bag)
    }
}
