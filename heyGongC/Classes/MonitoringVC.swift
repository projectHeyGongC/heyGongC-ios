//
//  MonitoringVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class MonitoringVC: BaseVC {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    private let viewModel = MonitoringVM()
    
    private var btnSettings: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.image = UIImage(named: "ic_notification")
        object.tintColor = .black
        return object
    }()
    
    //MARK: LifeCycle
    override func initialize() {
        viewModel.callUserInfo()
        viewModel.callDeviceList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = btnSettings
    }
    
    override func bind() {
        
        viewModel.successFetchUserInfo
            .bind {
                if $0 {
                    
                }
            }
            .disposed(by: viewModel.bag)
        
        bindAction()
        bindTableView()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... MonitoringVC ViewModel]")
        onBack(vm: viewModel)
    }
}

// MARK: - private
extension MonitoringVC {
    private func bindAction() {
        
        btnAdd.rx.tap
            .bind(onNext: { [weak self] in
                guard let self else { return }
                SegueUtils.open(target: self, link: .QRCodeReaderVC)
                
            }).disposed(by: viewModel.bag)
        
        btnSettings.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                
                
            }).disposed(by: viewModel.bag)
    }
    
    private func bindTableView() {
        
        viewModel.deviceList
            .filterNil()
            .bind(to: tableView.rx.items(cellIdentifier: "DeviceCell", cellType: DeviceCell.self)) {
                (index, element, cell) in
                
                cell.updateDisplay(element: element, index: index)
                cell.selectionStyle = .none
                
            }.disposed(by: viewModel.bag)
        
        viewModel.deviceList
            .filterNil()
            .bind { [weak self] _ in
            guard let self = self else { return }
            
            self.tableView.updateTableViewHeight(layout: self.tableViewHeight)
        }.disposed(by: viewModel.bag)
    }
}
