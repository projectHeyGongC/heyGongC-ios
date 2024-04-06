//
//  UITableView+Ext.swift
//  heyGongC
//
//  Created by 김은서 on 4/4/24.
//

import Foundation
import UIKit

extension UITableView {
    
    /// tableView total 높이 계산하기
    /// - Parameter layout: 해당 뷰의 레이아웃 (IBOutlet)
    ///  - !!! 반드시 셀 세팅 완료 이후에 호출
    public func updateTableViewHeight(layout: NSLayoutConstraint) {
        let height = self.calculateTotalCellHeight()
        layout.constant = height
        self.reloadData()
    }
    
    public func calculateTotalCellHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                totalHeight += self.rectForRow(at: indexPath).height
            }
        }
        
        return totalHeight
    }
}
