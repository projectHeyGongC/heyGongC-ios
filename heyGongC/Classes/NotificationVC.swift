//
//  NotificationVC.swift
//  heyGongC
//
//  Created by 김은서 on 1/23/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class NotificationVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = NotificationVM()
    
    //MARK: LifeCycle
    override func initialize() {
        self.viewModel.callNotification()
    }
    
    override func bind() {
        bindTableView()
    }
    
    override func setupHandler() {
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... NotificationVC ViewModel]")
        onBack(vm: viewModel)
    }
    
}

// MARK: - Private
extension NotificationVC {
    
    private func bindTableView() {
        
        viewModel.notificationList
            .filterNil()
            .bind(to: tableView.rx.items(cellIdentifier: "NotificationCell", cellType: NotificationCell.self)) { (index, element, cell) in
             
                cell.updateDisplay(element: element)
                
            }.disposed(by: viewModel.bag)
    }
    
}
