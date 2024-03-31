//
//  SavedPatternCell.swift
//  regexy
//
//  Created by Augusto Avelino on 29/03/24.
//

import UIKit

struct SavedPatternCellData {
    let name: String
    let pattern: String
}

class SavedPatternCell: UITableViewCell {
    static let reuseIdentifier = "SavedPatternCell"
    
    // MARK: Configure
    
    func configure(with cellData: SavedPatternCellData) {
        var configuration = defaultContentConfiguration()
        configuration.text = cellData.name
        configuration.secondaryText = cellData.pattern
        contentConfiguration = configuration
    }
}
