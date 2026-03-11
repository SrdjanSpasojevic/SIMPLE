//
//  DatabaseService.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation
import SwiftData

protocol DatabaseService: Sendable {
    func get<T: PersistentModel>(where predicate: Predicate<T>?) async throws -> [T]
    func save<T: PersistentModel>(_ model: T) async throws
    func remove<T: PersistentModel>(_ model: T) async throws
}
