//
//  UIView + Ext.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     부모뷰에 자식뷰 한꺼번에 넣기
     */
    func autoAddSubview(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
