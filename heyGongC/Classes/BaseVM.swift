//
//  BaseVM.swift
//  heyGongC
//
//  Created by EUNSEO 2023/12/25.
//

import Foundation
import RxSwift
import RxCocoa

class VM {
    public func clearBag() { }
    var bag = DisposeBag()
    final var errorHandler = BehaviorRelay<QTError?>(value: nil)
}

class BaseVM: VM {

    // var title: String?
    
    public override func clearBag() {
        self.bag = DisposeBag()
    }
}
