//
//  RegexDAO.swift
//  regexy
//
//  Created by Augusto Avelino on 29/03/24.
//

import CoreData

// MARK: Interface

protocol RegexDAOProtocol {
    func create(named name: String, pattern: String) throws
    func fetchList() throws -> [PatternEntity]
    func fetch(_ id: String) throws -> PatternEntity?
    func delete(_ id: String) throws -> PatternEntity?
}

// MARK: - Implementation

class RegexDAO: RegexDAOProtocol {
    
    // MARK: Properties
    
    weak var context: NSManagedObjectContext?
    
    // MARK: - Data handling
    
    func create(named name: String, pattern: String) throws {
        guard let context = context else { throw RegexDAOError.noContext }
        let entity = PatternEntity(context: context)
        entity.id = UUID().uuidString
        entity.name = name
        entity.pattern = pattern
        let date = Date()
        entity.createdAt = date
        entity.updatedAt = date
        try saveContext()
    }
    
    func fetchList() throws -> [PatternEntity] {
        guard let context = context else { throw RegexDAOError.noContext }
        let fetchRequest = PatternEntity.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    func fetch(_ id: String) throws -> PatternEntity? {
        guard let context = context else { throw RegexDAOError.noContext }
        let fetchRequest = PatternEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(fetchRequest).first
    }
    
    func delete(_ id: String) throws -> PatternEntity? {
        guard let context = context else { throw RegexDAOError.noContext }
        if let deleted = try fetch(id) {
            context.delete(deleted)
            try saveContext()
            return deleted
        }
        return nil
    }
    
    func saveContext() throws {
        guard let context = context else { throw RegexDAOError.noContext }
        try context.save()
    }
}

// MARK: - Errors

enum RegexDAOError: Error {
    case noContext
}
