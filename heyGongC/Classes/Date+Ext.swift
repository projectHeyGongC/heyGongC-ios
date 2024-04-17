//
//  Date+Ext.swift
//  heyGongC
//
//  Created by 장예지 on 2/12/24.
//

import Foundation

extension Date {
    func convertDateToString(dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    /**
     yyyyMMdd 형태로 변경
     */
    func makeToYMD() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }

    /**
     yyyy-MM-dd 형태로 변경
     */
    func makeToY_M_D() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
