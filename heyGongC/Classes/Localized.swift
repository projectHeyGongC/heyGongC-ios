//
//  Localized.swift
//  heyGongC
//
//  Created by 김은서 2023/12/25.
//

import Foundation
import SwiftyUserDefaults

// MARK: - Localized
enum Localized {
    case ERROR_MSG

    /**
     *  다국어 처리
     */
    var txt: String {
        switch self {
        case .ERROR_MSG:
            return "잠시 후 시도해주세요"
        }
    }
}

