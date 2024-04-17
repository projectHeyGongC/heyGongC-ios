//
//  LottieIndicator.swift
//  heyGongC
//
//  Created by 김은서 on 4/16/24.
//
import Foundation
import Lottie
import SnapKit
import Then

class LottieIndicator {
    
    static let shared = LottieIndicator()
    private let animationView = AnimationView(name:"loading")
    
    private let container = UIView()
    private let bg = UIView()
    
    public func show() {
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first {
            
            addSubviews(keyWindow)
            setupLayoutViews()
            
            //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
            animationView.play()
        }
    }
    
    public func dismiss() {
        animationView.pause()
        animationView.stop()
        container.removeFromSuperview()
        bg.removeFromSuperview()
    }
    
    private func addSubviews(_ keyWindow: UIWindow) {
        //메인 뷰에 삽입
        keyWindow.addSubview(container)
        container.autoAddSubview([bg, animationView])
        container.backgroundColor = .clear
        bg.backgroundColor = .black
        bg.alpha = 0.5
        
        animationView.contentMode = .scaleAspectFit

        //애니메이션 재생모드( .loop = 애니메이션 무한재생)
        animationView.loopMode = .loop
        
    }
    
    private func setupLayoutViews() {
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.size.width.height.equalTo(80)
            $0.center.equalToSuperview()
        }
    }
}
