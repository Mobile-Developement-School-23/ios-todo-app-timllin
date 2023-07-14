//
//  SQLDataStorage.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 12.07.2023.
//

import Foundation
import SQLite

public class SQLDataStorage {
    static let shared = SQLDataStorage()

    let dirDatabase = "SQLiteDB"
    let storeName = "toDoItem.sqlite3"

    private let items = Table("items")

    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let importanceType = Expression<String>("importanceType")
    private let deadline = Expression<Date?>("deadline")
    private let flag = Expression<Bool>("flag")
    private let creationDate = Expression<Date>("creationDate")
    private let changeDate = Expression<Date?>("changeDate")
    private let hexCode = Expression<String?>("hexCode")

    private var dbConnection: Connection? = nil

    private init() {
        if let docDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(dirDatabase)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbConnectionPath = dirPath.appendingPathComponent(storeName).path
                dbConnection = try Connection(dbConnectionPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbConnectionPath) ")
            } catch {
                dbConnection = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            dbConnection = nil
        }
    }

    private func createTable() {
        guard let database = dbConnection else { return }
        do {
            try database.run(items.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(importanceType)
                table.column(deadline)
                table.column(flag)
                table.column(creationDate)
                table.column(changeDate)
                table.column(hexCode)
            })
        } catch {
            print(error)

        }
    }
}

extension SQLDataStorage {
    public func load() -> [Any] {
        guard let database = dbConnection else { return [] }
        var data = [[String: Any?]]()
        do {
            for item in try database.prepare(items) {
                let itemDict: [String: Any?] = ["id": item[id],
                                "text": item[text],
                                "importanceType": item[importanceType],
                                "deadline": item[deadline],
                                "flag": item[flag],
                                "creationDate": item[creationDate],
                                "changeDate": item[changeDate],
                                "hexCode": item[hexCode]
                ]
                data.append(itemDict)
            }
        } catch {
            print(error)
        }
        return data
    }

    public func insertUpdate(of item: TodoItem) {
        guard let database = dbConnection else { return }

        let insert = items.insert(or: .replace, self.id <- item.getId(),
                                  self.text <- item.getText(),
                                  self.importanceType <- item.getImportanceTypeString(),
                                  self.deadline <- item.getDeadline(),
                                  self.flag <- item.getFlag(),
                                  self.creationDate <- item.getCreationDate(),
                                  self.changeDate <- item.getChangeDate(),
                                  self.hexCode <- item.getHexCode())
        do {
            try database.run(insert)
        } catch {
            print(error)
        }

    }

    public func delete(of item: TodoItem) {
        guard let database = dbConnection else { return }

        do {
            let filter = items.filter(self.id == item.getId())
            try database.run(filter.delete())
        } catch {
            print(error)
        }
    }
}
