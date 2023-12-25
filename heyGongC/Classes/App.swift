//
//  App.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import UIKit
import SwiftyUserDefaults

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
    
    var lastConnectionError = false
    var isReachable = true
    
    var firebaseDynamicLink = ""
    var curatorInfo: CuratorInfo?        // kes 221226 딥링크로 들어왔을때만 저장하기 위해
    
    // kes 230510 유진 딥링크로 들어왔는지 (앱 종료시 삭제해야하기에 App.shared 로 )
    var egPBDeepLink = false
    
    var coupon: String?        // kes 230724 쿠폰 등록 [type,num] 관련 (지류쿠폰은 번호 없는 빈값 -> 일반 유저와 비교 위해 optional)
                               // kes 230905 딥링크에 linkAction 추가로 type값 삭제
    
    var introType = IntroType.authorized
    
    var pushInfo: PushInfo?
    var hasPushEvent = false
    var hasDeepLink = false
    
    /* 메인화면 갱신 옵션 */
    var refreshMain = false
    /* 투자화면 갱신 옵션 */
    var refreshProduct = false
    /* 자산화면 갱신 옵션 */
    var refreshAsset = false
    /* 모의자산화면 갱신 옵션 */
    var refreshMockAsset = false
    /* 모의전략상세화면 갱신 옵션 */
    var refreshMockProductDetail = false
    
    var size = Size()
    
    var deviceToken = "" {
        didSet {
            print("🟠 [DEVICE TOKEN] \(self.deviceToken)")
        }
    }
    
    var accessToken = "" {
        didSet {
            print("🟠 [ACCESS TOKEN] \(self.accessToken)")
        }
    }
    
    var pushToken = "" {
        didSet {
            print("🟠 [PUSH TOKEN] \(self.pushToken)")
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
    
    ///파이도에 필요한 토큰
    func saveAuthCode(from: String, code: String) {
        Defaults.AUTH_CODE = code
        print("🟠 SAVED AUTHCODE : \(from) [\(Defaults.AUTH_CODE)]")
    }
    
}
