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
    
    @IBOutlet weak var viewOn: UIView!
    @IBOutlet weak var viewOff: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContents: UILabel!
    
    public func clear() {
        lblName.text = ""
        lblContents.text = ""
    }
    
    public func updateDisplay(element: AnalysisModel.Notification?, index: Int) {
        guard let element = element else { return }
        
        // kes 240410 Analysis 화면에서 최대 3개까지는 빈 배열 보내줌
        // kes 240410 -> deviceID가 nil 일 경우 cell Off로 표시
        if let _ = element.deviceID {
            viewOff.isHidden = true
            viewOn.isHidden = false
            
            lblName.text = element.deviceName
            lblContents.text = element.contents
        } else {
            viewOff.isHidden = false
            viewOn.isHidden = true
        }
    }
    
}
