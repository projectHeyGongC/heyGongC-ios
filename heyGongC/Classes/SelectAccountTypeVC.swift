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
    
    enum LoginType: String {
        case Google = "Google"
        case Kakao = "Kakao"
        case Apple = "Apple"
    }
    
    @IBOutlet weak var collectionViewOnboarding: UICollectionView!
    @IBOutlet weak var btnGoogle: CSUIButton!
    @IBOutlet weak var btnKakao: CSUIButton!
    @IBOutlet weak var btnApple: CSUIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    private let viewModel = SelectAccountTypeVM()
    
    private var onboardingImage = ["img_slide_1","img_slide_2","img_slide_3"]
    private var onboardingText = ["수상한 소리가 나면 주인한테 알려줘요","무슨 소리가 났었는지 확인할 수 있어요","언제 어디서 소리가 났는지 볼 수 있어요"]
    private var currentPage = 0
    
    override func initialize() {
        collectionViewOnboarding.delegate = self
        collectionViewOnboarding.dataSource = self
        btnApple.setAttributeStingBold(specificText: "Apple")
        btnGoogle.setAttributeStingBold(specificText: "Google")
    }
    
    override func bind() {
        bindAction()
    }
    
    override func setupHandler() { 
        self.setErrorHandler(vm: viewModel)
    }
    
    /// viewModel로 파라미터 전달
    /// - Parameter ads: 마케팅 동의 여부
    public func updateData(ads: Bool) {
        self.viewModel.ads = ads
    }
}
// MARK: - Private
extension SelectAccountTypeVC {
    private func bindAction() {
        
        btnGoogle.rx.tap
            .bind(onNext: {[weak self] in
                guard let self = self else { return }
                
                self.loginForGoogle()
            }).disposed(by: viewModel.bag)
    }
}

extension SelectAccountTypeVC {
    
    private func loginForGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
            guard let self,
                  let result = signInResult,
                  let token = result.user.idToken?.tokenString else { return }
            print(result, token)
            // 서버에 토큰을 보내기. 이 때 idToken, accessToken 차이에 주의할 것
        }
    }
}

// MARK: - Delegate
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
