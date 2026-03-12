//
//  MockDataService.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 12. 3. 2026..
//


protocol MockDataService: Sendable {
    func seedUsersIfNeeded() async
}