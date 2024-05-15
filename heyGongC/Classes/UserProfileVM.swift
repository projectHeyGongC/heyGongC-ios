//
//  UserProfileVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/10/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa



class UserProfileVM: BaseVM {
    var deviceList = BehaviorRelay<[DeviceModel]?>(value: [])
    var userEmail = BehaviorRelay<String?>(value: KeyChains.shared.USER_DATA?.email)
    var logintType = BehaviorRelay<LoginType?>(value: LoginType(rawValue: KeyChains.shared.USER_DATA?.snsType ?? ""))
    
    
    func callDeviceList(){
        DeviceAPI.shared.networking(deviceService: .devices, type: [DeviceModel].self)
            .subscribe(onSuccess: { [weak self] networkResult in
                guard let self else { return }
                switch networkResult {
                case .success(let devices):
                    deviceList.accept(devices)
                case .error(let error):
                    errorHandler.accept(error)
                }
            }, onFailure: { _ in
                print("error - UserProfileVM")
            })
            .disposed(by: bag)
    }
    
    func disconnectDevices(){
        guard let devices = deviceList.value else { return }
        let params = DeviceParam.DeviceDisconnectRequest(deviceIds: devices.compactMap { $0.deviceId })
        
        DeviceAPI.shared.networking(deviceService: .disconnect(param: params), type: DeviceModel.self)
            .subscribe(onSuccess: { networkResult in
                switch networkResult {
                case .success:
                    self.callDeviceList()
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { _ in
                print("error - disconnectDevices")
            })
            .disposed(by: bag)
    }
}
