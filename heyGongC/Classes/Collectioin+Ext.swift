//
//  Collectioin+Ext.swift
//  heyGongC
//
//  Created by 김은서 on 4/10/24.
//

import Foundation

//배열 등등 crash 방지
extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
