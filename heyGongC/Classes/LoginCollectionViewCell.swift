//
//  LoginCollectionViewCell.swift
//  heyGongC
//
//  Created by 장예지 on 1/8/24.
//

import UIKit

class LoginCollectionViewCell: UICollectionViewCell {
    static var identifier = String(describing: LoginCollectionViewCell.self)
    @IBOutlet weak var lblOnboardingTitle: UILabel!
    @IBOutlet weak var imgViewOnboarding: UIImageView!
}
