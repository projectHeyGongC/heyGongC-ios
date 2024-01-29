//
//  CreateAccountVM.swift
//  heyGongC
//
//  Created by 김은서 on 12/25/23.
//

import Foundation
import RxSwift
import RxCocoa

class ExampleVM: BaseVM {
    private func getExample() {
        UserService.shared.getUserInfo().subscribe(with: self, onS)
    }
}
