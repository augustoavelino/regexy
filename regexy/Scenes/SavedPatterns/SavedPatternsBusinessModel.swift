//
//  SavedPatternsBusinessModel.swift
//  regexy
//
//  Created by Augusto Avelino on 31/03/24.
//

import Foundation

protocol SavedPatternsBusinessModelProtocol {
    func fetchList() throws -> [PatternEntity]
    func deletePattern(atIndex patternIndex: Int) throws -> PatternEntity?
}

class SavedPatternsBusinessModel: SavedPatternsBusinessModelProtocol {
    
    let dao: RegexDAOProtocol
    private(set) var entities: [PatternEntity] = []
    
    init(dao: RegexDAOProtocol) {
        self.dao = dao
    }
    
    func fetchList() throws -> [PatternEntity] {
        if !entities.isEmpty { return entities }
        entities = try dao.fetchList()
        return entities
    }
    
    func deletePattern(atIndex patternIndex: Int) throws -> PatternEntity? {
        guard patternIndex < entities.count else { throw SavedPatternsBusinessModelError.indexOutOfBounds }
        guard let removedID = entities.remove(at: patternIndex).id else { throw SavedPatternsBusinessModelError.unknown }
        return try dao.delete(removedID)
    }
}

enum SavedPatternsBusinessModelError: Error {
    case indexOutOfBounds, unknown
}
