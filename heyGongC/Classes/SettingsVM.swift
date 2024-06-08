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
                    Defaults.removeAll()
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
        // kes 240608 Defaults.removeAll()을 안하는 이유 _ FCMToken은 appDelegate에서 받아오기에 로그아웃 이후 바로 재로그인 시도할 경우 FCMToken이 없어서 로그인 불가
        Defaults.token = nil
        Defaults.loginType = nil
        Defaults.deviceList = nil
        self.completLogout.accept(true)
    }
}
