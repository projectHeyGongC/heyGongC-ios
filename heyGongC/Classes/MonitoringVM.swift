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

class MonitoringVM: BaseVM {
    public var successFetchUserInfo = BehaviorRelay<Bool>(value: false)
    
    func fetchUserInfo(){
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
                print("fetchUserInfo - error")
            })
            .disposed(by: self.bag)

    }
}
