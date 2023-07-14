//
//  FileCache+CoreData.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 13.07.2023.
//

import Foundation

extension FileCache {
    public func loadCoreData() {
        let data = CoreDataStorage.shared.load()
        for item in data {
            if let newItem = TodoItem.parse(coreDataResponse: item) {
                self.add(item: newItem)
            }
        }
    }

    public func insertCoreData(item: TodoItem) {
        CoreDataStorage.shared.insert(of: item)
    }

    public func updateCoreData(item: TodoItem) {
        CoreDataStorage.shared.update(of: item)
    }

    public func deleteCoreData(item: TodoItem) {
        CoreDataStorage.shared.delete(of: item)
    }

    public func insertManyCoreData(items: [TodoItem]) {
        for item in items {
            CoreDataStorage.shared.insert(of: item)
        }
    }
}
