//
//  UIButton+Ext.swift
//  heyGongC
//
//  Created by 김은서 on 3/16/24.
//

import Foundation
import UIKit

extension UIButton {
    /**
     네비게이션 닫기버튼 커스텀 필요할 때
     */
    func createCloseButton() {
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.setImage(UIImage(named: "ic_header_x"), for: .normal)
    }
}
