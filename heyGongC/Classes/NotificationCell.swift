//
//  NotificationCell.swift
//  heyGongC
//
//  Created by 김은서 on 3/3/24.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var lblNotification: UILabel!
    
    public func updateDisplay(element: NotificationModel) {
        
        lblNotification.text = element.content
    }
}
