//
//  FullCalendarVC.swift
//  heyGongC
//
//  Created by 장예지 on 2/1/24.
//

import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults
import FSCalendar
import RxRelay

protocol IsSelectedDate {
    func pass(date: Date)
}

class FullCalendarVC: UIViewController {
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var fullCalendar: FSCalendar!
    @IBOutlet weak var btnFullCalendarLastMonth: UIButton!
    @IBOutlet weak var btnFullCalendarNextMonth: UIButton!
    @IBOutlet weak var lblFullCalendarHeader: UILabel!
    
    private var fullCalendarCurrentPage: Date?
    private let disposeBag = DisposeBag()
    
    var delegate: IsSelectedDate?
    var selectedDateRelay = BehaviorRelay<Date?>(value: Date.now)
    
    override func viewDidLoad() {
        initFullCalendar()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.viewBackground.alpha = 0.4
        }
    }
    
    private func bind() {
        btnFullCalendarLastMonth.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                moveCurrentPage(next: true)
            }
            .disposed(by: bag)
        
        btnFullCalendarNextMonth.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                moveCurrentPage(next: false)
            }
            .disposed(by: bag)
        
        selectedDateRelay
        .bind{ [weak self] date in
            guard let self = self else { return }
            fullCalendar.select(date)
        }
        .disposed(by: bag)
    }
    
    private func initFullCalendar() {
        fullCalendar.tag = 1
        fullCalendar.dataSource = self
        fullCalendar.delegate = self
        
        fullCalendar.scope = .month
        fullCalendar.scrollEnabled = true
        fullCalendar.pagingEnabled = true
        
        fullCalendar.headerHeight = 0
        
        // kes 240118 text 관련 설정
        fullCalendar.appearance.weekdayFont = .systemFont(ofSize: 16, weight: .medium)
        fullCalendar.appearance.titleFont = .systemFont(ofSize: 16, weight: .regular)
        
        fullCalendar.appearance.weekdayTextColor = GCColor.C_9291A5
        fullCalendar.appearance.titleTodayColor = GCColor.C_000000
        fullCalendar.appearance.todaySelectionColor = GCColor.C_006877
        fullCalendar.appearance.todayColor = .clear
        fullCalendar.appearance.selectionColor = GCColor.C_006877
        fullCalendar.placeholderType = .none
        fullCalendar.firstWeekday = 2
        
        lblFullCalendarHeader.text = Date.now.convertDateToString(dateFormat: "MMMM yyyy")
    }
    
    private func moveCurrentPage(next: Bool){
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = next ? -1 : 1
        fullCalendarCurrentPage = cal.date(byAdding: dateComponents, to: fullCalendarCurrentPage ?? Date.now)
        self.fullCalendar.setCurrentPage(fullCalendarCurrentPage!, animated: true)
    }
    
}

extension FullCalendarVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        UIView.animate(withDuration: 0.3) {
            self.viewBackground.alpha = 0
        } completion: { _ in
            self.viewBackground.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.delegate?.pass(date: calendar.selectedDate ?? Date.now)
            self.dismiss(animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.lblFullCalendarHeader.text = calendar.currentPage.convertDateToString(dateFormat: "MMMM yyyy")
    }
}


