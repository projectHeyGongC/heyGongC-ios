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
import AuthenticationServices


class SelectAccountTypeVC: BaseVC {
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
        self.setupNavigationBar(type: .fullScreen)
        collectionViewOnboarding.delegate = self
        collectionViewOnboarding.dataSource = self
        btnApple.setAttributeStingBold(specificText: "Apple")
        btnGoogle.setAttributeStingBold(specificText: "Google")
    }
    
    override func bind() {
        bindSuccess()
        bindAction()
    }
    
    override func setupHandler() { 
        self.setErrorHandler(vm: viewModel)
    }
    
    deinit {
        print("[Clear... SelectAccountTypeVC ViewModel]")
        onBack(vm: viewModel)
    }
}

// MARK: - Private
extension SelectAccountTypeVC {
    
    private func bindSuccess() {
        viewModel.loginSuccess
            .bind { [weak self] in
            
            guard let self else { return }
            
            if $0 {
                SegueUtils.open(target: self, link: .MainTBC)
            }
            
        }.disposed(by: viewModel.bag)
        
        viewModel.goRegister.bind { [weak self] in
            guard let self else { return }
            
            if $0 {
                if let vc = Link.CreateAccountVC.viewController as? CreateAccountVC {
                    guard let param = self.viewModel.param else { return }
                    
                    vc.updateParam(param: param)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }.disposed(by: viewModel.bag)
    }
    
    private func bindAction() {
        
        btnGoogle.rx.tap
            .bind(onNext: {[weak self] in
                guard let self = self else { return }
                
                self.loginForGoogle()
            }).disposed(by: viewModel.bag)
        
        btnApple.rx.tap
            .bind(onNext: { [weak self] in
                guard let self else { return }
                
                self.loginForApple()
                
            }).disposed(by: viewModel.bag)
    }
}

extension SelectAccountTypeVC {
    
    private func loginForGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
            guard let self,
                  let result = signInResult?.user else { return }

            self.viewModel.callLogin(loginType: .Google, accessToken: result.accessToken.tokenString)
        }
    }
    
    private func loginForApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
               
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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

// MARK: - AppleLoginDelegate
extension SelectAccountTypeVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            if let identityToken = appleIDCredential.identityToken,
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("identifyTokenString: \(identifyTokenString)")
                
                self.viewModel.callLogin(loginType: .Apple, accessToken: identifyTokenString)
            }
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
