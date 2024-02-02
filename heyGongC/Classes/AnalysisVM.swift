//
//  AnalysisVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class AnalysisVM: BaseVM {
    var selectedDate = BehaviorRelay<Date?>(value: Date.now)
    
    public func updateDate(_ date: Date) {
        self.selectedDate.accept(date)
    }
}
