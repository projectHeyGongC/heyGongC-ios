//
//  AnalysisVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import FSCalendar

class AnalysisVC: BaseVC {
    
    @IBOutlet weak var viewHeaderCalendar: FSCalendar!
    
    private let viewModel = AnalysisVM()
    
    override func initialize() {
        initCalendar()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        
    }
    
    deinit {
        print("[Clear... AnalysisVC ViewModel]")
        onBack(vm: viewModel)
    }
}

extension AnalysisVC {
    
    private func initCalendar() {
        viewHeaderCalendar.dataSource = self
        viewHeaderCalendar.delegate = self
        
        viewHeaderCalendar.scope = .week
        viewHeaderCalendar.scrollEnabled = false
        viewHeaderCalendar.pagingEnabled = false
        viewHeaderCalendar.calendarHeaderView.isHidden = true
        viewHeaderCalendar.appearance.weekdayFont = .systemFont(ofSize: 12, weight: .regular)
        viewHeaderCalendar.appearance.weekdayTextColor = GCColor.C_94A3B8
        viewHeaderCalendar.appearance.todayColor = GCColor.C_000000
        viewHeaderCalendar.appearance.selectionColor = GCColor.C_006877
    }
}

extension AnalysisVC: FSCalendarDataSource, FSCalendarDelegate {
    
}
