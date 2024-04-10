//
//  CreateAccountVM.swift
//  heyGongC
//
//  Created by 장예지 on 1/8/24.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import SwiftyUserDefaults

enum AgreementButtonType {
    case allAgree // 전체 동의
    case requiredFirst // 필수 동의 첫번째
    case requiredSecond // 필수 동의 두번째
    case notRequiredThird // 선택 사항
}

struct Input {
    let buttonTapped = PublishRelay<AgreementButtonType>()
}

class CreateAccountVM: BaseVM {
    struct Param {
        var loginType: LoginType
        var accessToken: String
        var refreshToken: String
    }
    
    public var param: Param?
    
    let allAgreeIsSelected = BehaviorRelay<Bool>(value: false)
    let requiredFirstIsSelected = BehaviorRelay<Bool>(value: false)
    let requiredSecondIsSelected = BehaviorRelay<Bool>(value: false)
    let notRequiredThirdIsSelected = BehaviorRelay<Bool>(value: false)
    
    public var successRegister = BehaviorRelay<Bool>(value: false)
    
    var input = Input()
    
    override init(){
        super.init()
        
        input.buttonTapped
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                
                switch type {
                case .allAgree:
                    let preValue = self.allAgreeIsSelected.value
                    [
                        self.allAgreeIsSelected,
                        self.requiredFirstIsSelected,
                        self.requiredSecondIsSelected,
                        self.notRequiredThirdIsSelected
                    ].forEach { $0.accept(!preValue) }
                case .requiredFirst:
                    self.requiredFirstIsSelected.accept(!self.requiredFirstIsSelected.value)
                case .requiredSecond:
                    self.requiredSecondIsSelected.accept(!self.requiredSecondIsSelected.value)
                case .notRequiredThird:
                    self.notRequiredThirdIsSelected.accept(!self.notRequiredThirdIsSelected.value)
                }
            })
            .disposed(by: self.bag)
        
        Observable.combineLatest(
            requiredFirstIsSelected,
            requiredSecondIsSelected,
            notRequiredThirdIsSelected)
        { $0 && $1 && $2}
            .bind(to: allAgreeIsSelected)
            .disposed(by: self.bag)
    }
    
    
    // MARK: - callApi
    /// 회원가입
    public func callRegister() {
        
        guard let data = self.param else { return }
        
        // TODO: 토큰 관련 api 정리되면 필요없는 하단 변수 정리
        let param = UserParam.RegisterRequest(ads: notRequiredThirdIsSelected.value, snsType: data.loginType.rawValue, accessToken: data.accessToken)
        
        UserAPI.shared.networking(userService: .register(param: param), type: Token.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    guard let token = response else { return }
                    
                    ServiceAPI.shared.refreshToken(token: token)
                    Defaults.LOGIN_TYPE = data.loginType
                    self.successRegister.accept(true)
                    
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callRegister - error")
                
            }).disposed(by: self.bag)
    }
}
