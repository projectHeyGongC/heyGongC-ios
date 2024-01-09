//
//  CreateAccountVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/8/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults

class CreateAccountVC: BaseVC {
    
    var viewModel: CreateAccountVM = CreateAccountVM()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnAllAgree: UIButton!
    @IBOutlet weak var btnRequiredFirst: UIButton!
    @IBOutlet weak var btnRequiredSecond: UIButton!
    @IBOutlet weak var btnNotRequiredThird: UIButton!
    @IBOutlet weak var btnNextButton: UIButton!
    @IBOutlet weak var viewMarketingAgreement: UIView!
    @IBOutlet weak var lblMarketingAgreement: UILabel!
    
    var isViewAppear: Bool = true
    var dateNow: String {
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: Date.now)
        }
    }
    
    override func initialize() {
        viewMarketingAgreement.isHidden = true
        setupUI()
    }
    
    override func bind() {
        Observable<AgreementButtonType>.merge([
            btnAllAgree.rx.tap.map { _ in .allAgree },
            btnRequiredFirst.rx.tap.map { _ in .requiredFirst },
            btnRequiredSecond.rx.tap.map { _ in .requiredSecond },
            btnNotRequiredThird.rx.tap.map { _ in .notRequiredThird }
        ])
        .bind(to: viewModel.input.buttonTapped)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel.requiredFirstIsSelected,
            viewModel.requiredSecondIsSelected)
        { $0 && $1 }
            .subscribe{ isEnabled in
                self.btnNextButton.backgroundColor = isEnabled ? UIColor(named: "ffc000") : UIColor(named: "c4c4c4")
                self.btnNextButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        
        viewModel.allAgreeIsSelected
            .bind { [weak self] isSelected in
                let imageName = isSelected ? "ic_radioButton_on" : "ic_radioButton_off"
                self?.btnAllAgree.setImage(UIImage(named: imageName), for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.requiredFirstIsSelected
            .bind{ [weak self] isSelected in
                // 버튼 이미지 업데이트 로직을 여기에 추가합니다.
                let imageName = isSelected ? "ic_checkBox_on" : "ic_checkBox_off"
                self?.btnRequiredFirst.setImage(UIImage(named: imageName), for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.requiredSecondIsSelected
            .bind{ [weak self] isSelected in
                // 버튼 이미지 업데이트 로직을 여기에 추가합니다.
                let imageName = isSelected ? "ic_checkBox_on" : "ic_checkBox_off"
                self?.btnRequiredSecond.setImage(UIImage(named: imageName), for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.notRequiredThirdIsSelected
            .skip(1)
            .bind{ [weak self] isSelected in
                // 버튼 이미지 업데이트 로직을 여기에 추가합니다.
                let imageName = isSelected ? "ic_checkBox_on" : "ic_checkBox_off"
                self?.btnNotRequiredThird.setImage(UIImage(named: imageName), for: .normal)
                self?.showHideMarketingAgreementLabel(isSelected)
                
            }
            .disposed(by: disposeBag)
            
    }
    
    override func setupHandler() { }
    
    private func setupUI(){
        lblSubTitle.text = "서비스 시작 및 가입을 위해 먼저 가입 및\n 정보 제공에 동의해 주세요."
        lblSubTitle.font = UIFont.systemFont(ofSize: 11)
        
        btnNextButton.cornerRadius = 10
        setConfiguration(button: btnAllAgree, title: "아래 항목에 전체 동의합니다", font: UIFont.systemFont(ofSize: 14, weight: .semibold), imagePadding: 13, fontColor: .black, image: "ic_radioButton_off")
        
        let checkBoxBtnGroup = [btnRequiredFirst, btnRequiredSecond, btnNotRequiredThird]
        let checkBoxTitle = ["이용약관 동의 (필수)", "개인정보 처리 방침 동의 (필수)", "마케팅 정보 수신 동의 (선택)"]
        for i in 0..<checkBoxBtnGroup.count {
            setConfiguration(button: checkBoxBtnGroup[i]!, title: checkBoxTitle[i], font: UIFont.systemFont(ofSize: 13, weight: .regular), imagePadding: 12, fontColor: .black, image: "ic_checkBox_off")
        }
    }
    
    private func setConfiguration(button: UIButton, title: String, font: UIFont, imagePadding: CGFloat, fontColor: UIColor, image: String){
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer{ text in
            var newText = text
            newText.font = font
            return newText
        }
        configuration.imagePadding = imagePadding
        configuration.baseForegroundColor = fontColor
        configuration.image = UIImage(named: image)
        
        button.configuration = configuration
        button.contentHorizontalAlignment = .leading
    }
    
    private func showHideMarketingAgreementLabel(_ isSelected: Bool) {
        
        setLblMarketingAgreementText(isSelected)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){ UIView.animate(withDuration: 0.5) {
                self.viewMarketingAgreement.isHidden = false
                self.viewMarketingAgreement.alpha =  1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fadeOutMarketingAgreementView()
                }
            }
        }
    }
    
    private func fadeOutMarketingAgreementView(){
        UIView.animate(withDuration: 0.3) {
            self.viewMarketingAgreement.alpha = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.viewMarketingAgreement.isHidden = true
        }
    }
    
    private func setLblMarketingAgreementText(_ isSelected: Bool){
        let text = "[헤이공씨 앱 푸시 \(isSelected ? "동의" : "거부")] \(dateNow)\n 마케팅/혜택 알림 수신을 \(isSelected ? "동의" : "거부")하였습니다."
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        lblMarketingAgreement.attributedText = attributedString
    }
}
