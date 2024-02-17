//
//  DefaultsKeys.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//

import Foundation
import SwiftyUserDefaults

/**
 *  SharedPreferenceUtil.java
 */
                                                    
extension DefaultsKeys {
    //기본정보
    var REFRESH_TOKEN: DefaultsKey<String> { .init("REFRESH_TOKEN", defaultValue:"") }
    var ACCESS_TOKEN: DefaultsKey<String> { .init("ACCESS_TOKEN", defaultValue:"") }
    var AUTO_LOGIN: DefaultsKey<Bool> { .init("AUTO_LOGIN", defaultValue: false) }
    
    var IS_PUSH: DefaultsKey<Bool> { .init("IS_PUSH", defaultValue: false) }            // kes 230323 푸시 왔는지 체크 후 상단바 이미지 on/off
}
