//
//  DeviceNamingVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/17/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

class DeviceNamingVM: BaseVM {
    
    public var successAppendDevice = BehaviorRelay<Bool>(value: false)
    public var deviceId: String?
    public var name: String?
    
    public func callAppendDevice(){
        
        guard let deviceId = self.deviceId, let name = name else { return }
        
        let data = DeviceParam.InfoRequest(deviceId: deviceId, deviceName: name)
        
        DeviceAPI.shared.networking(deviceService: .subscribe(param: data), type: DeviceModel.self, isParsing: false)
            .subscribe(with: self,
                       onSuccess: { owner, networkValue in
                switch networkValue {
                case .success(_):
                    self.successAppendDevice.accept(true)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callAppendDevice - error")
            })
            .disposed(by: self.bag)
    }
}
