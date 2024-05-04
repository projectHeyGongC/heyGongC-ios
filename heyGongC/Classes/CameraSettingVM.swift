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
    
    private func getDeviceModel(type: ControlType, mode: ControlMode) -> DeviceModel? {
        guard let currentInfo = self.deviceInfo.value else { return nil }
        
        var deviceModel = currentInfo
        
        switch type {
        case .sensitivity:
            deviceModel.sensitivity = mode.value
        case .cameraOrientation:
            deviceModel.cameraOrientation = mode.value
        case .soundSensing:
            deviceModel.soundSensingStatus = mode.value
        default:
            break
        }
        return deviceModel
    }
    
    // MARK: - callAPI
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
    
    public func postDeviceControl(type: ControlType, mode: ControlMode) {
        guard let deviceId = deviceInfo.value?.deviceId else { return }
        
        let param = DeviceParam.DeviceControlRequest(controlType: type, controlMode: mode)
        
        DeviceAPI.shared.networking(deviceService: .control(deviceId: deviceId, param: param), type: BaseModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success:
                    let deviceModel = self.getDeviceModel(type: type, mode: mode)
                    self.deviceInfo.accept(deviceModel)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            },
            onFailure: { owner, error in
                print("postDeviceControl - error")
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
