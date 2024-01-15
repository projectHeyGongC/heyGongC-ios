//
//  PopupManager.swift
//  Quantec
//
//  Created by SEOJIN on 2022/05/17.
//

import Foundation
import Toast_Swift

class AlertConfig {
    
    enum Style {
        case `default`
        case cancel
    }
    
}

extension UIView {
    /**
     *  토스트
     */
    public func showToast(_ msg: String, duration: CGFloat = 2.0) {
        self.hideAllToasts()
        DispatchQueue.main.async {
            self.makeToast(msg, duration: duration)
        }
    }
}

extension UIViewController {
    // TODO: 같은 이름 함수 정리
    func showToast(_ msg: String, duration: CGFloat = 2.0) {
        self.view.showToast(msg, duration: duration)
    }
    
    func showAlert(localized: Localized,
                   isAccent: Bool = false,
                   confirm: (()->())? = nil,
                   cancel: (()->())? = nil) {
        
        let alert = UIAlertController(title: localized.title, message: localized.txt, preferredStyle: .alert)
        
        let textFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let attributes = NSMutableAttributedString(string: localized.title)
        
        if isAccent {
            let accentTitle = localized.title.split(separator: "\n")
            if accentTitle.count > 1 {
                attributes.addAttribute(.foregroundColor, value: UIColor.red, range: (localized.title as NSString).range(of: "\(accentTitle[1])"))
            }
            
            attributes.addAttribute(.font, value: textFont, range: (localized.title as NSString).range(of: "\(localized.title)"))
            alert.setValue(attributes, forKey: "attributedTitle")
        }
        
        
        if localized.confirmText != "" {
            let confirmAction = UIAlertAction(title: localized.confirmText, style: .default){ action in
                confirm?()
            }
            confirmAction.setValue(UIColor(red: 0/255, green: 104/255, blue: 119/255, alpha: 1), forKey: "titleTextColor")
            alert.addAction(confirmAction)
        }
        
        if localized.cancelText != "" {
            let cancelAction = UIAlertAction(title: localized.cancelText, style: .cancel){ action in
                cancel?()
            }
            cancelAction.setValue(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), forKey: "titleTextColor")
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true)
    }
    
}


