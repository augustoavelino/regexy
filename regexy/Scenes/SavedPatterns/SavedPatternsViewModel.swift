//
//  SavedPatternsViewModel.swift
//  regexy
//
//  Created by Augusto Avelino on 30/03/24.
//

import Foundation

// MARK: Interface

protocol SavedPatternsViewModelProtocol {
    func loadData() throws
    func numberOfItems() -> Int
    func dataForItem(atIndex index: Int) -> SavedPatternCellData?
    @discardableResult
    func deleteItem(atIndex index: Int) -> Bool
}

// MARK: - Implementation

class SavedPatternsViewModel: SavedPatternsViewModelProtocol {
    
    // MARK: Properties
    
    let businessModel: SavedPatternsBusinessModelProtocol
    var cellData: [SavedPatternCellData] = []
    
    // MARK: - Life cycle
    
    init(businessModel: SavedPatternsBusinessModelProtocol) {
        self.businessModel = businessModel
    }
    
    // MARK: - Fetching data
    
    func loadData() throws {
        let data = try businessModel.fetchList()
        cellData = data.map { SavedPatternCellData(name: $0.name ?? "", pattern: $0.pattern ?? "") }
    }
    
    func numberOfItems() -> Int {
        return cellData.count
    }
    
    func dataForItem(atIndex index: Int) -> SavedPatternCellData? {
        guard index < numberOfItems() else { return nil }
        return cellData[index]
    }
    
    @discardableResult
    func deleteItem(atIndex index: Int) -> Bool {
        do {
            let result = try businessModel.deletePattern(atIndex: index) != nil
            if result { cellData.remove(at: index) }
            return result
        } catch {
            debugPrint(error)
            return false
        }
    }
}
