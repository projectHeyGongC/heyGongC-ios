//
//  CustomButton.swift
//  heyGongC
//
//  Created by 김은서 on 1/24/24.
//

import Foundation
import UIKit

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
