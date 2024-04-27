//
//  DefaultsKeys.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//

import Foundation
import SwiftyUserDefaults

                                                    
extension DefaultsKeys {
    //기본정보
    var token: DefaultsKey<Token?> { .init("token", defaultValue: nil) }
    var loginType: DefaultsKey<LoginType?> { .init("loginType", defaultValue: nil) }
    var deviceList: DefaultsKey<[DeviceListModel]?> { .init("deviceList", defaultValue: nil) }
    var isPush: DefaultsKey<Bool> { .init("isPush", defaultValue: false) }
    var fcmToken: DefaultsKey<String> { .init("fcmToken", defaultValue: "") }
}
