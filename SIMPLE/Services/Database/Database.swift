//
//  Database.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftData
import Foundation

actor Database: DatabaseService {
    private let container: ModelContainer
    private var _context: ModelContext?

    init(container: ModelContainer) {
        self.container = container
    }

    private var context: ModelContext {
        if let modelContext = _context { return modelContext }
        let modelContextFromContainer = ModelContext(container)
        _context = modelContextFromContainer
        return modelContextFromContainer
    }

    func get<T: PersistentModel>(where predicate: Predicate<T>? = nil) async throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try context.fetch(descriptor)
    }

    func save<T: PersistentModel>(_ model: T) async throws {
        context.insert(model)
        try context.save()
    }

    func save() async throws {
        try context.save()
    }

    func remove<T: PersistentModel>(_ model: T) async throws {
        context.delete(model)
        try context.save()
    }
}
