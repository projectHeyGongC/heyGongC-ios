//
//  Segue.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//
import UIKit
import SafariServices
import SwiftyUserDefaults

struct Storyboard {
    static let Login                = "Login"
    static let Main                 = "Main"
    static let Product              = "Product"
    static let Invest               = "Invest"
    static let Account              = "Account"
}

class SegueUtils {
    /// 일반적으로 push 할 때 사용_ 전달되는 파라미터 없음
    /// - Parameters:
    ///   - target: 현재 화면
    ///   - link: 이동할 화면 (Link)
    ///   - animated: 애니메이션 유무
    static func open(target: UIViewController, link: Link, animated: Bool = true) {
        if let vc = link.viewController {
            target.navigationController?.pushViewController(vc, animated: animated)
        }
    }
}

extension SegueUtils {
    
    // 상품 상세 이동
    static func goToProductDetail(target: BaseVC, productInfoList: [PortBasicInfo], investType: INVEST_TYPE) {
        if let vc = Link.ProductDetailVC.viewController as? ProductDetailVC {
            vc.updateParam(productInfoList: productInfoList, invType: investType)
            target.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

enum Link: String {
//    case QratorRcmRegisterVC    = "QratorRcmRegisterVC"
    
    var baseStoryboard: String {
        switch self {
            
            // 약관
//        case .NewTermsVC:
//            return Storyboard.Terms
        }
    }
    
    var url: String {
        return self.rawValue
    }
    
    var viewController: UIViewController? {
        guard let sb = self.storyboard else { return nil }
        guard let id = self.segue else { return nil }
        
        return sb.instantiateViewController(identifier: id)
    }
    
    var baseViewController: BaseVC? {
        return viewController as? BaseVC
    }
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: self.baseStoryboard, bundle: nil)
    }
    
    var segue: String? {
        return self.rawValue
    }
}
