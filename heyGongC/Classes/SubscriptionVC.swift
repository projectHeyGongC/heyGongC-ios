//
//  SubscriptionVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/31/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults

class SubscriptionVC: BaseVC {
    override func initialize() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    override func bind() { }
    
    override func setupHandler() { }
}
