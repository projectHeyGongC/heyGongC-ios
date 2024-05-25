//
//  DeviceInfoCollectionViewCell.swift
//  heyGongC
//
//  Created by 장예지 on 1/11/24.
//

import UIKit
import RxSwift

class DeviceInfoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: DeviceInfoCollectionViewCell.self)
    
    @IBOutlet weak var deviceInfoView: UIView!
    @IBOutlet weak var ellipseView: UIView!
    @IBOutlet weak var imgViewDeviceType: UIImageView!
    @IBOutlet weak var btnDeviceSetting: UIButton!
    @IBOutlet weak var lblDeviceName: UILabel!
    
    public let bag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDeviceName.text = nil
    }
    
    func updateDisplay(deviceName: String){
        lblDeviceName.text = deviceName
    }
}
