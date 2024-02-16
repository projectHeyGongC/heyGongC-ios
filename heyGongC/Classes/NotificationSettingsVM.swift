//
//  NotificationSettingsVM.swift
//  heyGongC
//
//  Created by 김은서 on 2/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class NotificationSettingsVM: BaseVM {
    
    public var switchNotificationStatus = BehaviorRelay<Bool>(value: false)
    
    override init(){
        super.init()
        
        if let status = KeyChains.shared.USER_DATA?.alarm {
            switchNotificationStatus.accept(status)
        }
        
    }
}
