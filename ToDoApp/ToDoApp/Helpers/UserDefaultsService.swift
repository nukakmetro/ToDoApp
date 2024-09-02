//
//  UserDefaultsService.swift
//  ToDoApp
//
//  Created by surexnx on 02.09.2024.
//

import Foundation

protocol UserDefaultsProtocol {

    associatedtype T: Hashable & Codable

    init(_ key: String, encoder: JSONEncoder)
    func setAll(_ value: Set<T>)
    func get() -> Set<T>
    func set(_ value: T)
}

final class UserDefaultsService<T: Hashable & Codable>: UserDefaultsProtocol {

    private let defaults: UserDefaults
    private var key: String
    private let encoder: JSONEncoder
    
    init(_ key: String, encoder: JSONEncoder = JSONEncoder()) {
        self.defaults = UserDefaults.standard
        self.key = key
        self.encoder = JSONEncoder()
    }

    func setAll(_ value: Set<T>) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    func get() -> Set<T> {
        if let data = defaults.data(forKey: key),
           let set = try? JSONDecoder().decode(Set<T>.self, from: data) {
            return set
        }
        return Set<T>()
    }

    func set(_ value: T) {
        var set = get()
        set.insert(value)
        setAll(set)
    }
}
