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
    
    @IBOutlet weak var btnFullCalendar: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var viewHeaderCalendar: FSCalendar!
    @IBOutlet weak var viewFullCalendar: FSCalendar!
    @IBOutlet weak var viewHidden: UIView!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullCalendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnFullCalendarLastMonth: UIButton!
    @IBOutlet weak var btnFullCalendarNextMonth: UIButton!
    @IBOutlet weak var lblFullCalendarHeader: UILabel!
    
    private let viewModel = AnalysisVM()
    private var fullCalendarCurrentPage: Date?
    private lazy var fullCalendarHeaderDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    override func initialize() {
        viewHidden.isHidden = true
        
        initHeaderCalendar()
        initFullCalendar()
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
    
    private func initHeaderCalendar() {
        viewHeaderCalendar.tag = 0
        viewHeaderCalendar.dataSource = self
        viewHeaderCalendar.delegate = self
        
        viewHeaderCalendar.scope = .week
        viewHeaderCalendar.scrollEnabled = true
        viewHeaderCalendar.pagingEnabled = true
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
    
    private func initFullCalendar() {
        viewFullCalendar.tag = 1
        viewFullCalendar.dataSource = self
        viewFullCalendar.delegate = self
        
        viewFullCalendar.scope = .month
        viewFullCalendar.scrollEnabled = true
        viewFullCalendar.pagingEnabled = true
        
        viewFullCalendar.headerHeight = 0
        
        // kes 240118 text 관련 설정
        viewFullCalendar.appearance.weekdayFont = .systemFont(ofSize: 16, weight: .medium)
        viewFullCalendar.appearance.titleFont = .systemFont(ofSize: 16, weight: .regular)
        
        viewFullCalendar.appearance.weekdayTextColor = GCColor.C_9291A5
        viewFullCalendar.appearance.titleTodayColor = GCColor.C_000000
        viewFullCalendar.appearance.todaySelectionColor = .clear
        viewFullCalendar.appearance.todayColor = .clear
        viewFullCalendar.appearance.selectionColor = GCColor.C_006877
        viewFullCalendar.placeholderType = .none
        viewFullCalendar.firstWeekday = 2
        
        lblFullCalendarHeader.text = fullCalendarHeaderDateFormatter.string(from: Date.now)
    }
    
    private func moveCurrentPage(next: Bool){
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = next ? -1 : 1
        fullCalendarCurrentPage = cal.date(byAdding: dateComponents, to: fullCalendarCurrentPage ?? Date.now)
        self.viewFullCalendar.setCurrentPage(fullCalendarCurrentPage!, animated: true)
    }
    
    private func bindAction() {
        
        btnMore.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                SegueUtils.open(target: self, link: .RecordedVideoListVC, isPresent: true)
                
            }).disposed(by: viewModel.bag)
        
        btnFullCalendar.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                tabBarController?.tabBar.isHidden = true
                viewHidden.isHidden = false
                
            }).disposed(by: viewModel.bag)
        
        btnFullCalendarLastMonth.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                moveCurrentPage(next: true)
            }
            .disposed(by: viewModel.bag)
        
        btnFullCalendarNextMonth.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                moveCurrentPage(next: false)
            }
            .disposed(by: viewModel.bag)
    }
}

extension AnalysisVC: FSCalendarDataSource, FSCalendarDelegate {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.viewModel.updateDate(date)
        
        if calendar.tag == 0 {
            // kes 240120 headerCalendar
        
        } else if calendar.tag == 1 {
            // kes 240120 popupCalendar
            tabBarController?.tabBar.isHidden = false
            viewHidden.isHidden = true
        }
    }
    
    // 날짜 선택 해제 콜백 메소드
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.tag == 0 {
            // kes 240120 headerCalendar
        
        } else if calendar.tag == 1 {
            // kes 240120 popupCalendar
            
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.lblFullCalendarHeader.text = self.fullCalendarHeaderDateFormatter.string(from: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if calendar.tag == 0 {
            // kes 240120 headerCalendar
            self.calendarHeightConstraint.constant = bounds.height
        } else if calendar.tag == 1 {
            // kes 240120 popupCalendar
            self.fullCalendarHeightConstraint.constant = bounds.height
        }
        self.view.layoutIfNeeded()
    }
}
