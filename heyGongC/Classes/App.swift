//
//  App.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import UIKit
import SwiftyUserDefaults
import DeviceCheck

/**
 *  디버그 프린트
 */
public func print(_ object: Any...) {
    #if DEBUG
    for item in object {
        Swift.print(item)
    }
    #endif
}

/**
 *  디버그 프린트 (Single)
 */
public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}


enum IntroType {
    case generate
    case login
    case authorized
}

let appDel = (UIApplication.shared.delegate as! AppDelegate)
let appKeyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first

struct PushInfo {
    var link_url: String
    var portfolio_grp: String
    var type: String
}

enum Release {
    case none
    case soft
    case hard
    case dev
    case prod
}

class App {
    
    struct Size {
        let tabbarHeight = 49
        let buttonViewHeight = 110.0
        let buttonHeight = 60.0
    }
    
    static let shared = App()
    
    #if DEBUG
    var release = Release.dev
    #else
    var release = Release.prod
    #endif
    
    var introType = IntroType.authorized
    
    var pushInfo: PushInfo?
    var hasPushEvent = false
    var hasDeepLink = false
//    
//    /* 메인화면 갱신 옵션 */
//    var refreshMain = false
//    /* 투자화면 갱신 옵션 */
//    var refreshProduct = false
//    /* 자산화면 갱신 옵션 */
//    var refreshAsset = false
//    /* 모의자산화면 갱신 옵션 */
//    var refreshMockAsset = false
//    /* 모의전략상세화면 갱신 옵션 */
//    var refreshMockProductDetail = false
    
    var size = Size()
    
    var deviceToken = "" {
        didSet {
            print("🟠 [DEVICE token] \(self.deviceToken)")
        }
    }
    
    var accessToken = "" {
        didSet {
            print("🟠 [ACCESS token] \(self.accessToken)")
        }
    }
    
    var pushToken = "" {
        didSet {
            print("🟠 [PUSH token] \(self.pushToken)")
        }
    }
    
    var udid = "" {
        didSet {
            print("🟠 [UDID] \(self.udid)")
        }
    }
    
    var idfa = "" {
        didSet {
            print("🟠 [IDFA] \(self.idfa)")
        }
    }
    
}
