//
//  BaseNavigationVC.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import Foundation

class MainViewController: UIViewController { }

class BaseNavigationVC: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let _ = self.topViewController as? MainViewController {
            return .lightContent
        } else {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                // Fallback on earlier versions
                return .default
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            primary()
        } else {
            let backButtonBackgroundImage = UIImage(named: "ic_header_back")
            let barAppearance =
                UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationVC.self])
            barAppearance.backIndicatorImage = backButtonBackgroundImage
            barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
            barAppearance.shadowImage = UIImage()
            
            let barButtonAppearance =
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationVC.self])
            barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .default)
            barButtonAppearance.tintColor = .red
        }
    }
    
    func primary() {
        updateDisplay(color: QTColor.C_FFFFFF)
    }
    
    private func updateDisplay(color: UIColor?) {
        if #available(iOS 13.0, *) {
            setNavigationBarAppearance(color: color)
        } else {
            self.navigationBar.barTintColor = color
            self.navigationBar.isTranslucent = false
        }
    }
    
    private func setNavigationBarAppearance(color: UIColor?) {
        if #available(iOS 13.0, *) {
            let backButtonBackgroundImage = UIImage(named: "ic_header_back")?.withRenderingMode(.alwaysOriginal)
            
            let attributes = [NSAttributedString.Key.foregroundColor: QTColor.C_201E33,
                              NSAttributedString.Key.font: UIFont.customFont(font: .H3B)]

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titlePositionAdjustment = UIOffset(horizontal: -200, vertical: 0)
            appearance.setBackIndicatorImage(backButtonBackgroundImage, transitionMaskImage: backButtonBackgroundImage)
            appearance.titleTextAttributes = attributes
            appearance.shadowColor = color
            navigationBar.standardAppearance = appearance;
            
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
}
