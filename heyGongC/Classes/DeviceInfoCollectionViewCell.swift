//
//  DeviceInfoCollectionViewCell.swift
//  heyGongC
//
//  Created by 장예지 on 1/11/24.
//

import UIKit

class DeviceInfoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: DeviceInfoCollectionViewCell.self)
    
    @IBOutlet weak var deviceInfoView: UIView!
    @IBOutlet weak var ellipseView: UIView!
    @IBOutlet weak var imgViewDeviceType: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    
    override var isHighlighted: Bool {
        didSet{
            if self.isHighlighted {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.alpha = 0.5
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.alpha = 1.0
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDeviceName.text = nil
    }
    
    func configure(deviceName: String){
        lblDeviceName.text = deviceName
    }
}
