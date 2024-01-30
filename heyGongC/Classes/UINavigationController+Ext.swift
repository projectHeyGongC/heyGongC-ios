//
//  UINavigationController+Extension.swift
//  Quantec
//
//  Created by 홍서진 on 2022/05/23.
//

import UIKit

//MARK: - public
extension UINavigationController {
   
    public func backToIntro() {
        let sb = UIStoryboard(name: "Initial", bundle: nil)
        let intro = sb.instantiateViewController(withIdentifier: "SplashView")
        self.setViewControllers([intro], animated: false)
    }
    
    public func backToMain() {
        self.popToRootViewController(animated: true)
    }
    
    /**
     *  쌓인 네비게이션 스택 중 특정 뷰로 pop
     */
    public func popPushToVC(ofKind kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            pushViewController(pushController, animated: true)
        }
    }
    
    func popRootWithCompletion(animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popVCWithCompletion(animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func ​pushVCWithCompletion(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

//MARK: - private
extension UINavigationController{
    /**
     *  네비게이션 스택에 특정 뷰가 있는지 없는지
     *  popPushToVC()에서 사용
     */
    private func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}

//MARK: - 사용안함
extension UINavigationController{
    
    /**
     *  현재 사용안함
     */
    public func removeSubrangeMain(){
        let totalViewControllers = self.viewControllers.count
        let start = 1
        let end = totalViewControllers - 1
        let range = start..<end
        self.viewControllers.removeSubrange(range)
    }
    
    /**
     *  현재 사용안함
     */
    public func removeSubrangeSelf() {
        let totalViewControllers = self.viewControllers.count
        let start = totalViewControllers - 2
        let end = totalViewControllers - 1
        let range = start..<end
        self.viewControllers.removeSubrange(range)
    }
    
    /**
     *  특정 개수만큼 뒤로 가기
     *  현재 사용안함
     */
    public func removePreviousController(total: Int){
        let totalViewControllers = self.viewControllers.count
        self.viewControllers.removeSubrange(totalViewControllers-total..<totalViewControllers - 1)
    }
}
