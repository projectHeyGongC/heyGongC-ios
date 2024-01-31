//
//  BaseNavigationVC.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import Foundation
import UIKit

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
            let backButtonBackgroundImage = UIImage(named: "ic_left_arrow")
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
        updateDisplay(color: UIColor.white)
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
            let backButtonBackgroundImage = UIImage(named: "ic_left_arrow")?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0))
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            //appearance.titlePositionAdjustment = UIOffset(horizontal: -200, vertical: 0)
            appearance.setBackIndicatorImage(backButtonBackgroundImage, transitionMaskImage: backButtonBackgroundImage)
            appearance.titleTextAttributes = attributes
            appearance.shadowColor = color
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
}
