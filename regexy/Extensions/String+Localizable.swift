//
//  String+Localizable.swift
//  regexy
//
//  Created by Augusto Avelino on 01/04/24.
//

import Foundation

enum AppString: String {
    case cancel
    case confirm
    case remove
    
    case loremIpsum
    
    case patternCopyToastMessage
    
    case patternLoadButton
    case patternLoadScreenTitle
    case patternLoadToastMessage
    
    case patternRemoveDialogMessage
    case patternRemoveDialogTitle
    
    case patternSaveButton
    case patternSaveDialogMessage
    case patternSaveDialogTitle
    case patternSaveToastMessage
    
    var key: String.LocalizationValue { String.LocalizationValue(rawValue) }
}

extension String {
    static func localized(appString: AppString, _ options: any CVarArg...) -> String {
        return String(format: String(localized: appString.key), options)
    }
}
