//
//  MonitoringVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftyUserDefaults

class MonitoringVM: BaseVM {
    enum ApiResult {
        case fetchUserInfo
        case sensorOn(index: Int)
        case sensorOff(index: Int)
    }
    
    public var apiResult = BehaviorRelay<ApiResult?>(value: nil)
    public var deviceList = BehaviorRelay<[DeviceListModel]?>(value: nil)
    public var sensorList = [Bool]()
    
    // MARK: - callApi
    public func callUserInfo(){
        UserAPI.shared.networking(userService: .info, type: UserModel.self)
            .subscribe(with: self,
            onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    KeyChains.shared.USER_DATA = response
                    self.apiResult.accept(.fetchUserInfo)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callUserInfo - error")
            })
            .disposed(by: self.bag)
    }
    
    public func callDeviceList() {
        DeviceAPI.shared.networking(deviceService: .devices, type: [DeviceListModel].self)
            .subscribe(with: self,
            onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    Defaults.deviceList = response
                    self.deviceList.accept(response)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callDeviceList- error")
            })
            .disposed(by: self.bag)
    }
    
    public func callSensor(index: Int, controlMode: ControlMode) {
        guard let deviceInfo = self.deviceList.value?[exist: index] else { return }
        
        let param = DeviceParam.DeviceControlRequest(controlType: .soundSensing, controlMode: controlMode)
        
        DeviceAPI.shared.networking(deviceService: .control(deviceId: deviceInfo.deviceId, param: param), type: BaseModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success:
                    switch controlMode {
                    case .on:
                        self.apiResult.accept(.sensorOn(index: index))
                    case .off:
                        self.apiResult.accept(.sensorOff(index: index))
                    default:
                        break
                    }
                case .error(let error):
                    switch controlMode {
                    case .on:
                        self.apiResult.accept(.sensorOff(index: index))
                    case .off:
                        self.apiResult.accept(.sensorOn(index: index))
                    default:
                        break
                    }
                    self.errorHandler.accept(error)
                }
            },
            onFailure: { owner, error in
                print("postDeviceControl - error")
            })
            .disposed(by: bag)
    }
}
