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
        case monitoring = "모니터링"
        case analysis = "분석"
        case subscription = "프리미엄"
        case userProfile = "프로필"
        
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
    @objc private func updatePushEvent() {
        App.shared.hasPushEvent = false
    }
    
    public func moveToTab(tab: Tab) {
        self.navigationController?.popToRootViewController(animated: false)
        selectTab(tab: tab)
    }
    
    //MARK: UI 그리기
    private func setupStyle() {
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .white)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: .white)
        
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
