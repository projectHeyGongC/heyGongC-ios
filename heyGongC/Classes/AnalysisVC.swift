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
import Kingfisher

class AnalysisVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeaderCalendar: FSCalendar!
    
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var lblNoVideo: UILabel!
    
    private let viewModel = AnalysisVM()
    
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
    
    override func initialize() {
        viewModel.updateDate(Date())
        setupLeftBarButtonUI()
        initHeaderCalendar()
        initUI()
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
        bindTableView()
        bindCalendar()
    }
    
    deinit {
        print("[Clear... AnalysisVC ViewModel]")
        onBack(vm: viewModel)
    }
}

// MARK: - UI
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
}

// MARK: - Bind
extension AnalysisVC {
    
    private func initUI() {
        self.tableView.separatorStyle = .none
    }
    
    private func bindUI() {
        
        self.viewModel.videoImgUrl
            .bind { [weak self] in
                guard let self = self else { return }
                if let imgUrl = $0 {
                    self.imgVideo.isHidden = false
                    self.lblNoVideo.isHidden = true
                    if let url = URL(string: imgUrl) {
                        imgVideo.kf.setImage(with: url)
                    }
                } else {
                    self.imgVideo.isHidden = true
                    self.lblNoVideo.isHidden = false
                }
            }.disposed(by: viewModel.bag)
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
    }
    
    private func bindCalendar() {
        viewModel.selectedDate
            .filterNil()
            .subscribe { [weak self] date in
                guard let self = self else { return }
                guard let selectedDate = viewModel.selectedDate.value else { return }
                
                lblSelectedDayOfMonth.text = selectedDate.convertDateToString(dateFormat: "dd")
                lblSelectedSpecificDate.text = selectedDate.convertDateToString(dateFormat: "EEE\nMMM yyyy")
                viewHeaderCalendar.select(viewModel.selectedDate.value)
                
                self.viewModel.callAnalysis(date: date)
            }.disposed(by: viewModel.bag)
    }
    
    private func bindTableView() {
        
        viewModel.tableData
            .filterNil()
            .bind(to: tableView.rx.items(cellIdentifier: "AnalysisNotiCell", cellType: AnalysisNotiCell.self)) {
                (index, element, cell) in
                
                cell.selectionStyle = .none
                cell.updateDisplay(element: element, index: index)
                
            }.disposed(by: viewModel.bag)
        
        viewModel.tableData
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.tableView.updateTableViewHeight(layout: self.tableViewHeight)
            }.disposed(by: viewModel.bag)
        
        
        // 테이블 뷰 선택
        Observable.zip(tableView.rx.modelSelected(AnalysisModel.Notification.self), tableView.rx.itemSelected)
            .bind { [weak self] (model, indexPath) in
                guard let stringDate = self?.viewModel.selectedDate.value?.makeToY_M_D() else { return }
                
                // kes 240410 Analysis 화면에서 최대 3개까지는 빈 배열 보내줌
                // kes 240410 -> deviceID가 nil 일 경우 cell Off로 표시
                if let _ = model.deviceID {
                    if let vc = Link.CameraAnalysisVC.viewController as? CameraAnalysisVC {
                        let param = CameraAnalysisVM.Param(data: model, date: stringDate)
                        vc.updateParam(param: param)
                        
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .disposed(by: viewModel.bag)
    }
}

// MARK: - FSCalendarDelegate
extension AnalysisVC: FSCalendarDataSource, FSCalendarDelegate {
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.viewModel.updateDate(date)
        tabBarController?.tabBar.isHidden = false
    }
    
    // 날짜 선택 해제 콜백 메소드
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) { }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}

// MARK: - Custom Delegate
extension AnalysisVC: IsSelectedDate {
    func pass(date: Date) {
        viewModel.updateDate(date)
    }
}
