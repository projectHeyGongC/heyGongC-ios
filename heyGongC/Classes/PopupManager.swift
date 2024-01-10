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
                   confirm: (()->())? = nil,
                   cancel: (()->())? = nil) {
        
        let alert = UIAlertController(title: localized.title, message: localized.txt, preferredStyle: .alert)
        
        if localized.confirmText == "" {
            let confirmAction = UIAlertAction(title: localized.confirmText, style: .default){ action in
                confirm?()
            }
            alert.addAction(confirmAction)
        }
        
        if localized.cancelText == "" {
            let cancelAction = UIAlertAction(title: localized.cancelText, style: .cancel){ action in
                cancel?()
            }
            
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true)
    }
    
}


