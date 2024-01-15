//
//  DeviceInfoCollectionViewCell.swift
//  heyGongC
//
//  Created by 장예지 on 1/11/24.
//

import UIKit

class DeviceInfoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: DeviceInfoCollectionViewCell.self)
    
    @IBOutlet weak var ellipseView: UIView!
    @IBOutlet weak var imgViewDeviceType: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDeviceName.text = nil
    }
    
    func configure(deviceName: String){
        lblDeviceName.text = deviceName
    }
}
