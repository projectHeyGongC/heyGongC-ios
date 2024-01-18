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
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var viewHeaderCalendar: FSCalendar!
    @IBOutlet weak var viewFullCalendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullCalendarHeightConstraint: NSLayoutConstraint!
    
    private let viewModel = AnalysisVM()
    
    override func initialize() {
        initCalendar()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    override func bind() {
        bindAction()
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
        
        // kes 240118 text 관련 설정
        viewHeaderCalendar.appearance.weekdayFont = .systemFont(ofSize: 12, weight: .regular)
        viewHeaderCalendar.appearance.titleFont = .systemFont(ofSize: 18, weight: .semibold)
        viewHeaderCalendar.appearance.weekdayTextColor = GCColor.C_94A3B8
        viewHeaderCalendar.appearance.titleTodayColor = GCColor.C_000000
        viewHeaderCalendar.appearance.titleSelectionColor = GCColor.C_006877
        
        viewHeaderCalendar.appearance.todaySelectionColor = .clear
        viewHeaderCalendar.appearance.todayColor = .clear
        viewHeaderCalendar.appearance.selectionColor = .clear
    }
    
    private func bindAction() {
        
        btnMore.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                SegueUtils.open(target: self, link: .RecordedVideoListVC)
                
            }).disposed(by: viewModel.bag)
    }
}

extension AnalysisVC: FSCalendarDataSource, FSCalendarDelegate {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    // 날짜 선택 해제 콜백 메소드
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
