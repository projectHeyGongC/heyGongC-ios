//
//  SelectAccountTypeVC.swift
//  heyGongC
//
//  Created by 장예지 on 1/8/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftyUserDefaults
import GoogleSignIn


class SelectAccountTypeVC: BaseVC {
    
    
    @IBOutlet weak var collectionViewOnboarding: UICollectionView!
    @IBOutlet weak var btnGoogle: CSUIButton!
    @IBOutlet weak var btnKakao: CSUIButton!
    @IBOutlet weak var btnApple: CSUIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    var viewModel: SelectAccountTypeVM = SelectAccountTypeVM()
    var onboardingImage = ["img_slide_1","img_slide_2","img_slide_3"]
    var onboardingText = ["수상한 소리가 나면 주인한테 알려줘요","무슨 소리가 났었는지 확인할 수 있어요","언제 어디서 소리가 났는지 볼 수 있어요"]
    var currentPage = 0
    
    override func initialize() {
        collectionViewOnboarding.delegate = self
        collectionViewOnboarding.dataSource = self
        btnApple.setAttributeStingBold(specificText: "Apple")
        btnGoogle.setAttributeStingBold(specificText: "Google")
    }
    
    override func bind() {
        
    }
    
    override func setupHandler() { 
        
    }
}

extension SelectAccountTypeVC {
    private func bindAction() {
        
        btnGoogle.rx.tap
            .bind(onNext: {
                
            }).disposed(by: viewModel.bag)
    }
}

extension SelectAccountTypeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginCollectionViewCell.identifier, for: indexPath) as! LoginCollectionViewCell
        cell.lblOnboardingTitle.text = onboardingText[indexPath.row]
        cell.imgViewOnboarding.image = UIImage(named: onboardingImage[indexPath.row])
              return cell
    }
}

extension SelectAccountTypeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageController.currentPage = currentPage
    }
}

extension SelectAccountTypeVC {
    
    private func loginForGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
                    guard let self,
                          let result = signInResult,
                          let token = result.user.idToken?.tokenString else { return }
                    // 서버에 토큰을 보내기. 이 때 idToken, accessToken 차이에 주의할 것
                }
    }
}

@IBDesignable class CSUIButton: UIButton {
    
    @IBInspectable var icon: UIImage? {
        didSet{
            csIconView.image = icon
        }
    }
    
    @IBInspectable override var backgroundColor: UIColor? {
        didSet {
            baseView.backgroundColor = backgroundColor
        }
    }
    
    @IBInspectable override var borderColor: UIColor? {
        didSet {
            baseView.borderColor = borderColor
        }
    }
    
    @IBInspectable override var borderWidth: CGFloat {
        didSet {
            baseView.borderWidth = borderWidth
        }
    }
    
    @IBInspectable override var cornerRadius: CGFloat {
        didSet{
            baseView.cornerRadius = cornerRadius
            self.layer.cornerRadius = cornerRadius
            iconBackgroundView.layer.cornerRadius = cornerRadius
            iconBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        }
    }
    
    @IBInspectable var iconBackgroundColor: UIColor? {
        didSet{
            iconBackgroundView.backgroundColor = iconBackgroundColor
        }
    }
    
    @IBInspectable var labelColor: UIColor? {
        didSet {
            csLabel.textColor = labelColor
        }
    }
    
    @IBInspectable var buttonTitle: String? {
        didSet {
            csLabel.text = buttonTitle
        }
    }
    
    private var csIconView: UIImageView = {
        var object = UIImageView()
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    private var csLabel: UILabel = {
        var object = UILabel()
        object.textAlignment = .center
        object.font = .systemFont(ofSize: 14, weight: .medium)
        return object
    }()
    
    private var iconBackgroundView: UIView = {
        var object = UIView()
        return object
    }()
    
    private var baseView: UIStackView = {
       var object = UIStackView()
        object.axis = .horizontal
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        setupButton()
    }
    
    private func setupButton() {
        self.setTitle("", for: .normal)
        
        baseView.isUserInteractionEnabled = false
        
        addSubview(baseView)
        iconBackgroundView.addSubview(csIconView)
        baseView.addSubview(iconBackgroundView)
        baseView.addSubview(csLabel)
        
        baseView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
        }
        
        iconBackgroundView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(42)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        csIconView.snp.makeConstraints { make in
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.centerY.centerX.equalToSuperview()
        }
        
        csLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-42)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    override var isHighlighted: Bool {
       didSet {
           if isHighlighted {
               self.alpha = 0.7
           } else {
               self.alpha = 1.0
           }
       }
   }
    
    func setAttributeStingBold(specificText: String){
        guard let text = self.csLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: (text as NSString).range(of: specificText))
        self.csLabel.attributedText = attributeString
        
    }
}
