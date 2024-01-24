//
//  SplashView.swift
//  heyGongC
//
//  Created by 김은서 on 1/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import Then

class SplashView: UIViewController {
    
    private lazy var lblTitle = UILabel().then {
        $0.text = "test"
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setUI()
        setLayout()
        SegueUtils.open(target: self, link: .SelectedAccountTypeVC)
    }
    
    private func setUI() {
        view.autoAddSubview([lblTitle])
    }
    
    private func setLayout() {
        lblTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
