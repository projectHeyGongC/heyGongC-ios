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
        print("alam is : \(KeyChains.shared.USER_DATA?.alarm)")
    }
    
    func changeNotificationStatus() {
        //jyj 20240509 alam 변경 API 구현 필요
        if let currentValue = changedNotificationSetting.value {
            self.changedNotificationSetting.accept(!currentValue)
        }
    }
}
