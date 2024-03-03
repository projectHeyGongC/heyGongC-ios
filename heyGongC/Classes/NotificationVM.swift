//
//  NotificationVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/23/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NotificationVM: BaseVM {
    
    public var notificationList = BehaviorRelay<[NotificationModel]?>(value: nil)
    
    public func callNotification() {
        NotificationAPI.shared.networking(notiService: .getList, type: [NotificationModel].self)
            .subscribe(with: self,
            onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    self.notificationList.accept(response)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("getList - error")
            })
            .disposed(by: self.bag)
    }
}
