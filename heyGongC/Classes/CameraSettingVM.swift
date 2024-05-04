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
    
    public func editDeviceName(name: String) -> Observable<String?> {
        guard let deviceId = deviceInfo.value?.deviceId else { return Observable.just(nil) }
        
        return Observable<String?>.create{ observe in
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
                        observe.onNext(name)
                    case .error(let error):
                        self.errorHandler.accept(error)
                    }
                },
                onFailure: { owner, error in
                    print("error - editDeviceName")
                })
                .disposed(by: self.bag)
            
            return Disposables.create()
        }
        
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

extension CameraSettingVM {
    struct Input{
        let editNameAlertTrigger: Observable<String?>
        let changedSensitivityAlertTrigger: Observable<Float>
        let changedCameraOrientationAlertTrigger: Observable<ControlMode>
    }
    
    struct Output{
        let deviceName = BehaviorRelay<String?>(value: "")
        let deviceModelName = BehaviorRelay<String>(value: "")
        let showEditNameToast = BehaviorRelay<Bool>(value: false)
        let sensitivityValue = BehaviorRelay<Float>(value: 0.0)
        let frontOrientationImage = BehaviorRelay<UIImage?>(value: nil)
        let backOrientationImage = BehaviorRelay<UIImage?>(value: nil)
    }
    
    func transform(input: Input) -> Output{
        let output = Output()
        
        input.editNameAlertTrigger
            .filterNil()
            .flatMap { name -> Observable<String?> in
                return self.editDeviceName(name: name)
            }
            .subscribe(onNext: { _ in
                output.showEditNameToast.accept(true)
            })
            .disposed(by: bag)
        
        input.changedSensitivityAlertTrigger
            .distinctUntilChanged()
            .map{ value -> ControlMode.Sensitivity in
                return self.getSensitivity(value: value)!
            }
            .bind{ value in
                self.postDeviceControl(type: .sensitivity, mode: .sensitivity(value))
            }
            .disposed(by: bag)
        
        input.changedCameraOrientationAlertTrigger
            .subscribe{ orientation in
                self.postDeviceControl(type: .cameraOrientation, mode: orientation)
            }
            .disposed(by: bag)
        
        deviceInfo
            .map{ $0?.deviceName }
            .filterNil()
            .bind(to: output.deviceName)
            .disposed(by: bag)

        deviceInfo
            .map{ $0?.modelName }
            .filterNil()
            .bind(to: output.deviceModelName)
            .disposed(by: bag)

        deviceInfo
            .map{ $0?.sensitivity }
            .filterNil()
            .map{ value -> Float in
                return ControlMode.Sensitivity(rawValue: value)?.sliderValue ?? 0.0
            }
            .bind(to: output.sensitivityValue)
            .disposed(by: bag)

        deviceInfo
            .map{ $0?.cameraOrientation }
            .filterNil()
            .bind { value in
                if value == "FRONT" {
                    output.frontOrientationImage.accept(UIImage(named: "ic_radioButton_on"))
                    output.backOrientationImage.accept(UIImage(named: "ic_radioButton_off"))
                } else {
                    output.frontOrientationImage.accept(UIImage(named: "ic_radioButton_off"))
                    output.backOrientationImage.accept(UIImage(named: "ic_radioButton_on"))
                }
            }
            .disposed(by: bag)

        return output
    }
    
    func getSensitivity(value: Float) -> ControlMode.Sensitivity? {
        switch value {
        case 0.0:
            return .veryLow
        case 0.25:
            return .low
        case 0.5:
            return .medium
        case 0.75:
            return .high
        case 1.0:
            return .veryHigh
        default:
            return nil
        }
    }
}
