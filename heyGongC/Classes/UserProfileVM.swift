//
//  UserProfileVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/10/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa



class UserProfileVM: BaseVM {
    let disconnectedAllDivices = PublishRelay<ActionType>()
    var devices: [String] = ["iPhone1", "iPhone2"]
    override init(){
        super.init()
        
    }
    
    func addDivice(){
        devices.append("iPhone3")
    }
}
