//
//  SettingsVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/15/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import SwiftyUserDefaults
import GoogleSignIn

class SettingsVM: BaseVM {
    
    public var completeUnregister = BehaviorRelay<Bool>(value: false)
    public var completLogout = BehaviorRelay<Bool>(value: false)
    
    public func callUnregister() {
        UserAPI.shared.networking(userService: .unregister, type: String.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(_):
                    GIDSignIn.sharedInstance.disconnect()
                    self.completeUnregister.accept(true)
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callUnregister - error")
                
            }).disposed(by: self.bag)
    }
    
    public func callLogout(){
        KeyChains.shared.USER_DATA = nil
        GIDSignIn.sharedInstance.signOut()
        Defaults.removeAll()
        self.completLogout.accept(true)
    }
}
