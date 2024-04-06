//
//  AnalysisCell.swift
//  heyGongC
//
//  Created by 김은서 on 4/4/24.
//
// kes 240404 분석 쪽 cell 정리

import Foundation
import UIKit

class AnalysisNotiCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContents: UILabel!
    
    public func clear() {
        lblName.text = ""
        lblContents.text = ""
    }
    
    public func updateDisplay(element: AnalysisModel.Notification) {
        lblName.text = element.deviceName
        lblContents.text = element.contents
    }
    
}
