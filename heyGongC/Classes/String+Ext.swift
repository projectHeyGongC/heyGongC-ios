//
//  String+Ext.swift
//  heyGongC
//
//  Created by 김은서 on 4/6/24.
//

import Foundation

extension String {
    
    /**
     문자열 나누는 함수
     */
    func substring(from: Int, to: Int) -> String {
        guard to < count, from >= 0, to - from >= 0 else {
            return self
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
