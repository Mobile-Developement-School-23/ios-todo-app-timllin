//
//  FileCache+SQLite.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 12.07.2023.
//

import Foundation

extension FileCache {
    public func loadSQL() {
        let data = SQLDataStorage.shared.load()

        for item in data {
            if let newItem = TodoItem.parse(sqlResponse: item) {
                self.add(item: newItem)
            }
        }
    }

    public func insertUpdateSQL(item: TodoItem) {
        SQLDataStorage.shared.insertUpdate(of: item)
    }

    public func deleteSQL(item: TodoItem) {
        SQLDataStorage.shared.delete(of: item)
    }

    public func insertManySQL(items: [TodoItem]) {
        for item in items{
            SQLDataStorage.shared.insertUpdate(of: item)
        }
    }
}
