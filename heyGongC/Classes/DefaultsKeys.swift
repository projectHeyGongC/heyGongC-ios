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
    var TOKEN: DefaultsKey<Token?> { .init("TOKEN", defaultValue: nil) }
    var LOGIN_TYPE: DefaultsKey<LoginType?> { .init("LOGIN_TYPE", defaultValue: nil) }
    
    var IS_PUSH: DefaultsKey<Bool> { .init("IS_PUSH", defaultValue: false) }
}
