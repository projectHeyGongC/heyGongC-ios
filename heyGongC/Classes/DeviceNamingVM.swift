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
    public var param: QRCodeReaderVM.Param?
    public var name: String?
    
    public func callAppendDevice(){
        
        guard let param = self.param, let name = name else { return }
        
        let data = DeviceParam.InfoRequest(parsedDeviceSeq: 0, deviceQR: param.deviceQR, name: name, type: param.type)
        
        DeviceAPI.shared.networking(deviceService: .add(param: data), type: DeviceModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkValue in
                switch networkValue {
                case .success(let response):
                    print(response)
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
