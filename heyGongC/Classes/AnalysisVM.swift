//
//  AnalysisVM.swift
//  heyGongC
//
//  Created by 김은서 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class AnalysisVM: BaseVM {
    var selectedDate = BehaviorRelay<Date?>(value: Date.now)
    var tableData = BehaviorRelay<[AnalysisModel.Notification]?>(value: nil)
    var video = BehaviorRelay<String?>(value: nil)
    
    public func updateDate(_ date: Date) {
        self.selectedDate.accept(date)
    }
    
    // MARK: - callAPI
    /// 로그인
    public func callAnalysis(date: Date?) {
        guard let date else { return }
        
        let stringDate = date.makeToYMD()
        
        AnalysisAPI.shared.networking(analysisService: .getAnalysis(requestAt: stringDate), type: AnalysisModel.self)
            .subscribe(with: self,
                       onSuccess: { owner, networkResult in
                switch networkResult {
                case .success(let response):
                    self.tableData.accept(response?.notifications)
                    self.video.accept(response?.videos)
                    
                case .error(let error):
                    self.errorHandler.accept(error)
                }
            }, onFailure: { owner, error in
                print("callAnalysis - error")
                
            }).disposed(by: self.bag)
    }
}
