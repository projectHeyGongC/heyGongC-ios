//
//  MainTBC.swift
//  Figma
//
//  Created by 김은서 on 2022/03/15.
//

import UIKit
import SwiftyUserDefaults
import Then
import SnapKit

//MARK: - enum
enum GCNotification {
    case Push
    case DeepLink
    case Airplane
    case GoHome
    
    var name: Notification.Name {
        switch self {
        case .Push: return Notification.Name("kPushRecv")
        case .DeepLink: return Notification.Name("kDeepLinkRecv")
        case .Airplane: return Notification.Name("Airplane")
        case .GoHome: return Notification.Name("GoHome")
        }
    }
}

//MARK: - Class
class MainTBC: UITabBarController {
    private var index = 0
    
    enum Tab: String{
        case monitoring = "홈"
        case analysis = "전략마켓"
        case subscription = "내 자산"
        case userProfile = "더보기"
        
        var index: Int {
            switch self {
                
            case .monitoring:
                return 0
            case .analysis:
                return 1
            case .subscription:
                return 2
            case .userProfile:
                return 3
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        //        self.navigationItem.hidesBackButton = true
        //        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(updatePushEvent), name: GCNotification.Push.name, object: nil)
        
        removeIntro()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRightButton()  // kes 230323 항상 알림 이미지 변경 되어야하기에 호출 시점 변경
        if App.shared.hasPushEvent {
            NotificationCenter.default.post(name: GCNotification.Push.name, object: nil)
        }
    }
    //TODO: Notification 앱 켜져있을때 안받기
//    //MARK: - linkType
//    public func moveToLinkType(linkType: LinkType, linkURL: String?) {
//        switch linkType {
//        case .LINK_TYPE_00: // 데이터 없음 (X)
//            break
//        case .LINK_TYPE_01: // 내 자산 탭
//            moveToTab(tab: .subscription)
//            
//        case .LINK_TYPE_02: // 공지사항 TODO: 설정탭으로 보낸 후 공지사항 뷰 띄우기
//            SegueUtils.open(target: self, link: .NoticeVC)
//            
//        case .LINK_TYPE_03: // 투자 탭
//            moveToTab(tab: .analysis)
//            
//        case .LINK_TYPE_04: // 해당 상품 상세화면
//            if let vc = self.viewControllers?[0] as? HomeVC {
//                Util.moveProdDetail(target: vc, portGrp: App.shared.pushInfo?.portfolio_grp ?? "KY000", invType: .REAL)
//            }
//            
//        case .LINK_TYPE_05: // 투자 성향
//            moveToTab(tab: .userProfile)
//            SegueUtils.openWebVC(target: self,
//                                 param: CommonWebVC.Param(webViewType: .wvPropensity, inflow: .START))
//            
//        case .LINK_TYPE_06: // 내 자산 > 해지 내역
//            moveToTab(tab: .subscription)
//            SegueUtils.open(target: self, link: .TerminationHistoryVC)
//            
//        case .LINK_TYPE_07:
//            // 투자 안내 _ 없어짐 kes 220906
//            // kes 230725 외부 웹뷰 _ 마케팅팀 요청
//            if let url = linkURL {
//                SegueUtils.openURL(urlString: url)
//            }
//        case .LINK_TYPE_08: // kes 230104 웹뷰 닫기 버튼
//            SegueUtils.openWebVC(target: self, param: CommonWebVC.Param(webViewType: .linkClose, url: linkURL))
//        case .LINK_TYPE_09: // 다운로드 링크 웹뷰 / 외부링크 (블로그)
//            SegueUtils.openWebVC(target: self, param: CommonWebVC.Param(webViewType: .linkNoAction, url: linkURL))
//        case .LINK_TYPE_10: // 다운로드 링크 웹뷰 + 해당 상품 상세화면
//            let portGrp = App.shared.pushInfo?.portfolio_grp ?? "KY000"
//            SegueUtils.openWebVC(target: self, param: CommonWebVC.Param(webViewType: .linkPortDetail, url: linkURL, portGrp: portGrp))
//        case .LINK_TYPE_11: // Q-Coin 웹뷰
//            SegueUtils.openWebVC(target: self, param: CommonWebVC.Param(webViewType: .linkQCoin))
//            
//        case .LINK_TYPE_12: // 투자 탭 (연금)
//            // kes 230308 연금/주식 탭 변경 이슈
//            // kes 231204 연금배너 이동
//            Util.linkAction(target: self, linkInfo: LinkInfo(linkType: .LINK_TYPE_10, linkUrl: TermsUrl.PensionEvent.url, portfolioGrp: "KY000"))
//        case .LINK_TYPE_13: // 계좌개설(위탁) 으로 가기
//            SegueUtils.open(target: self, link: .SelectAccOpenVC)
//        case .LINK_TYPE_14: // 계좌개설(연금) 으로 가기
//            SegueUtils.openKbWeb(target: self, accType: .PENSION)
//        case .LINK_TYPE_15: // 증권사 구분 으로 가기
//            SegueUtils.open(target: self, link: .SelectAccOpenVC)
//        case .LINK_TYPE_16: // 출금이체동의(연금) 으로 가기
//            SegueUtils.openWithAgree(target: self, accInfo: Util.getAccInfo(accType: .PENSION))
//        case .LINK_TYPE_17: // 모의투자 추천전략 화면
//            SegueUtils.open(target: self, link: .MockProductVC)
//        case .LINK_TYPE_18: // 홈 화면
//            moveToTab(tab: .monitoring)
//        case .LINK_TYPE_19: // 모의자산 화면
//            SegueUtils.open(target: self, link: .MockAssetVC)
//        case .LINK_TYPE_20,
//                .LINK_TYPE_21,
//                .LINK_TYPE_22,
//                .LINK_TYPE_23,
//                .LINK_TYPE_24,
//                .LINK_TYPE_25:
//            SegueUtils.openFaq(target: self, linkType: linkType.rawValue)
//        case .LINK_TYPE_26: // 내 쿠폰 사용가능 탭
//            if let vc = Link.CouponVC.viewController as? CouponVC {
//                vc.updateTab(defaultTab: 0)
//                
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        case .LINK_TYPE_27: // 내 쿠폰 완료/만료 탭
//            if let vc = Link.CouponVC.viewController as? CouponVC {
//                vc.updateTab(defaultTab: 1)
//                
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//    }
    
    @objc private func updatePushEvent() {
        App.shared.hasPushEvent = false
//        
//        if let linkType = LinkType(rawValue: App.shared.pushInfo?.type ?? "") {
//            // TODO: Test 후 적용
//            //            Util.linkAction(target: self, linkType: linkType, linkUrl: App.shared.pushInfo?.link_url)
//            self.moveToLinkType(linkType: linkType, linkURL: App.shared.pushInfo?.link_url)
//        }
    }
    
    public func moveToTab(tab: Tab) {
        self.navigationController?.popToRootViewController(animated: false)
        selectTab(tab: tab)
    }
    
    //MARK: UI 그리기
    private func setupStyle() {
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .white)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: .white)
        
        // kes 230328 탭바 커스텀 하기 위해서는 초기화해야함
        UITabBar.clearShadow()
        
        let color = GCColor.C_000000
        let selectedColor = GCColor.C_006877
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : selectedColor], for: .selected)
        
    }
    
    private func removeIntro() {
        self.navigationController?.setViewControllers([self], animated: true)
    }
    
    private func setupRightButton() {
        let button: UIButton = UIButton(type: .custom)
        
        let image = Defaults.IS_PUSH ? UIImage(named: "ic_header_noti_on") : UIImage(named: "ic_header_noti_off")
        guard let imageSize = image?.size else { return }
        
        button.setBackgroundImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(rightMenu), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func rightMenu() {
        print("rightMenu")
        Defaults.IS_PUSH = false
//        SegueUtils.open(target: self, link: Link.NotificationVC)
    }
    
    //MARK: - tabBar
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabTitle = item.title else { return }
        
        
        if let tab: Tab = Tab(rawValue: tabTitle) {
            if self.index == tab.index {
                return
            }
            
            self.index = tab.index
            
            if let vc = self.viewControllers?[tab.index] as? BaseVC {
                
                vc.refresh()
            }
        }
    }
    
    func selectTab(tab: Tab) {
        if let vc = self.viewControllers?[tab.index] as? BaseVC {
            vc.refresh()
        }
        self.selectedIndex = tab.index
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue)
    }
    
}

//MARK: - Extension
extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}


extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
