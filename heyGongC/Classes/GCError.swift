//
//  GCError.swift
//  heyGongC
//
//  Created by 김은서 on 12/27/23.
//

import Foundation
import Toast_Swift

// TODO: - 통합필요
enum GCError: Error {
    case expired
    case unknown(msg: String?)
    case e9990(msg: String?)    // 시스템에러
    case e9992(msg: String?)    // 필드누락
    case e9993(msg: String?)    // 개별메시지오류
    case e9998(msg: String?)    // 주문이 정상적으로 완료되지 못했습니다
    case errorJson
    case notFoundCode
    case retry
    case validation(validatainMsg: String)
}

enum GCErrorCode: String {
    case success        = "0000"
    case code9990       = "9990"
    case code9992       = "9992"
    case code9993       = "9993"
    case code9998       = "9998"
    case code9500       = "9500"    // cjlee 23/03/20 큐레이터 불일치
}

extension GCError {
    enum ProccessType {
        case basic
        case myAsset
    }
    
    // !!!: 아직 사용 안함
    func processError(target: UIViewController, type: ProccessType = .basic) {
        switch self {
        case .expired:
            print("expired")
        case .unknown(_):
            switch type {
            case .basic:
                print("basic")
            case .myAsset:
                print("expired")
            }
        case .e9990(_):
            print("9990")
        case .e9992(_):
            print("9992")
        case .e9993(_):
            print("9993")
        case .e9998(_):
            print("9998")
        case .retry:
            print("retry")
        case .errorJson:
            print("errorJson")
        case .notFoundCode:
            print("notFoundCode")
        case .validation:
            print("validation")
        }
    }
    
    func showErrorMsg(target: UIView) {
//        target.hideAllToasts()
        switch self {
        case .unknown(let msg),
            .e9990(msg: let msg),
            .e9992(msg: let msg),
            .e9993(msg: let msg),
            .e9998(msg: let msg):
            DispatchQueue.main.async {
                target.makeToast(msg)
            }
        case .validation(let msg):
            DispatchQueue.main.async {
                target.makeToast(msg)
            }
        default:
            print("🪫🪫🪫🪫 \(self)")
            target.makeToast(Localized.ERROR_MSG.txt)
            
            break
        }
    }
}
