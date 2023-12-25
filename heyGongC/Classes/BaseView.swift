//
//  BaseView.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupUI(frame)
        setupLayout(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(_ frame: CGRect) {}
    func setupLayout(_ frame: CGRect) {}
}
