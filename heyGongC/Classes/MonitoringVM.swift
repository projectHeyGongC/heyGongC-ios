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
    public var successFetchUserInfo = BehaviorRelay<Bool>(value: false)
    public var deviceList = BehaviorRelay<[DeviceListModel]?>(value: nil)
    
    public func callUserInfo(){
        UserAPI.shared.networking(userService: .info, type: UserModel.self)
            .subscribe(with: self,
            onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    KeyChains.shared.USER_DATA = response
                    self.successFetchUserInfo.accept(true)
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
}
