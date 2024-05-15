//
//  NotificationSettingsVM.swift
//  heyGongC
//
//  Created by 김은서 on 2/12/24.
//

import UserNotifications
import Foundation
import RxSwift
import RxCocoa

class NotificationSettingsVM: BaseVM {
    
    var changedNotificationSetting = BehaviorRelay<Bool?>(value: KeyChains.shared.USER_DATA?.alarm)
    
    override init(){
        super.init()
        
    }
    
    func changeNotificationStatus() {
        guard let alarm = changedNotificationSetting.value else { return }
        let data = UserParam.ChangeAlarmRequest(alarm: !alarm)
        
        UserAPI.shared.networking(userService: .changedAlarm(param: data), type: UserModel.self)
            .subscribe(onSuccess: { networkResult in
                switch networkResult {
                case .success:
                    self.changeUserData(data.alarm)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { _ in
                print("changeNotificationStatus - error")
            })
            .disposed(by: bag)
    }
    
    private func changeUserData(_ newValue: Bool){
        let currentValue = KeyChains.shared.USER_DATA
        
        KeyChains.shared.USER_DATA = UserModel(deviceID: currentValue?.deviceID, deviceOS: currentValue?.deviceOS, snsType: currentValue?.snsType, email: currentValue?.email, alarm: newValue, ads: currentValue?.ads)
        
        changedNotificationSetting.accept(newValue)
    }
}
