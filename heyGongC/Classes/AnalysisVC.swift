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

enum DateFormatType: String {
    case fullCalendarHeader = "MMMM yyyy"
    case selectedDay = "dd"
    case selectedSpecificDate = "EEE\nMMM yyyy"
}

protocol IsSelectedDate {
    func pass(date: Date)
}

class AnalysisVC: BaseVC {
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeaderCalendar: FSCalendar!
    
    private var btnFullCalendar: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.image = UIImage(named: "ic_calendar")
        object.tintColor = .black
        return object
    }()
    
    private var lblSelectedDayOfMonth: UILabel = {
       let object = UILabel()
        object.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return object
    }()
    
    private var lblSelectedSpecificDate: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 6, weight: .regular)
        object.numberOfLines = 0
        object.textColor = GCColor.C_94A3B8
        return object
    }()
    
    private var leftBarButtonItem : UIBarButtonItem = {
        let object = UIBarButtonItem()
        return object
    }()
    
    private let viewModel = AnalysisVM()
    
    override func initialize() {
        setupLeftBarButtonUI()
        initHeaderCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = btnFullCalendar
        navigationController?.navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil

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
    
    private func setupLeftBarButtonUI(){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.addArrangedSubview(lblSelectedDayOfMonth)
        stackView.addArrangedSubview(lblSelectedSpecificDate)
        leftBarButtonItem = UIBarButtonItem(customView: stackView)
        navigationController?.navigationBar.topItem?.setLeftBarButton(leftBarButtonItem, animated: false)
    }
    
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
    
    private func bindAction() {
        
        btnMore.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                
                SegueUtils.open(target: self, link: .RecordedVideoListVC, isPresent: true)
            }
            .disposed(by: viewModel.bag)
        
        btnFullCalendar.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }

                guard let reactionVC = storyboard?.instantiateViewController(withIdentifier: "FullCalendarVC") as? FullCalendarVC else { return }
                
                reactionVC.modalPresentationStyle = .overFullScreen
                reactionVC.delegate = self
                reactionVC.selectedDateRelay.accept(viewModel.selectedDate.value)
                self.present(reactionVC, animated: false, completion: nil)
            }
            .disposed(by: viewModel.bag)
        
        viewModel.selectedDate.subscribe { [weak self] date in
            guard let self = self else { return }
            guard let selectedDate = viewModel.selectedDate.value else { return }
            lblSelectedDayOfMonth.text = selectedDate.convertDateToStringWithDateFormatter(dateFormat: .selectedDay)
            lblSelectedSpecificDate.text = selectedDate.convertDateToStringWithDateFormatter(dateFormat: .selectedSpecificDate)
            viewHeaderCalendar.select(viewModel.selectedDate.value)
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if calendar.tag == 0 {
            // kes 240120 headerCalendar
            self.calendarHeightConstraint.constant = bounds.height
        } else if calendar.tag == 1 {
            // kes 240120 popupCalendar
        }
        self.view.layoutIfNeeded()
    }
}

extension AnalysisVC: IsSelectedDate {
    func pass(date: Date) {
        viewModel.updateDate(date)
    }
}
