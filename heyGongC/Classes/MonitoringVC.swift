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
import SwiftyUserDefaults

class MonitoringVC: BaseVC {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    private let viewModel = MonitoringVM()
    
    private var btnNotifications: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.image = UIImage(named: "ic_notification")
        object.tintColor = .black
        return object
    }()
    
    //MARK: LifeCycle
    override func initialize() {
        viewModel.callUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.callDeviceList()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = btnNotifications
    }
    
    override func bind() {
        
        viewModel.apiResult
            .filterNil()
            .bind { [weak self] result in
                switch result {
                case .fetchUserInfo:
                    break
                case .sensorOn(let index):
                    self?.updateCellSensoring(index: index, status: .On)
                case .sensorOff(let index):
                    self?.updateCellSensoring(index: index, status: .Off)
                }
            }.disposed(by: viewModel.bag)
        
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
        
        btnNotifications.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                
            }).disposed(by: viewModel.bag)
        
        
    }
    
    private func bindTableView() {
        
        viewModel.deviceList
            .filterNil()
            .bind(to: tableView.rx.items(cellIdentifier: "DeviceCell", cellType: DeviceCell.self)) {
                (index, element, cell) in
                
                cell.selectionStyle = .none
                cell.btnSettings.tag = index
                cell.switchSoundSensitivity.tag = index
                cell.updateDisplay(element: element)
                
            }.disposed(by: viewModel.bag)
        
        viewModel.deviceList
            .filterNil()
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.tableView.updateTableViewHeight(layout: self.tableViewHeight)
            }.disposed(by: viewModel.bag)
    }
}

extension MonitoringVC {
    private func updateCellSensoring(index: Int, status: DeviceCell.SensorStatus) {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DeviceCell {
            cell.updateSensorStatus(status: status)
        }
    }
}

extension MonitoringVC {
    
    @IBAction func goSetting(_ sender: UIButton) {
        guard let deviceInfo = self.viewModel.deviceList.value?[exist: sender.tag] else { return }
        
        if let vc = Link.CameraSettingVC.viewController as? CameraSettingVC {
            vc.updateParam(deviceId: deviceInfo.deviceId)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func switchSensor(_ sender: UISwitch) {
        let controlMode: ControlMode = sender.isOn ? .on : .off
        self.viewModel.callSensor(index: sender.tag, controlMode: controlMode)
    }
}
