//
//  SavedPatternCell.swift
//  regexy
//
//  Created by Augusto Avelino on 29/03/24.
//

import UIKit

// MARK: Data

struct SavedPatternCellData {
    let name: String
    let pattern: String
}

// MARK: - Cell

class SavedPatternCell: UITableViewCell {
    static let reuseIdentifier = "SavedPatternCell"
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            self.accessoryType = selected ? .checkmark : .none
        }
    }
    
    func configure(with cellData: SavedPatternCellData) {
        var configuration = defaultContentConfiguration()
        configuration.text = cellData.name
        configuration.secondaryText = cellData.pattern
        contentConfiguration = configuration
    }
}
