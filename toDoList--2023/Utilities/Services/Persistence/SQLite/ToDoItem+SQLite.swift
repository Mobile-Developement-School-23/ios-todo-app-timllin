//
//  ToDoItem+SQLite.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 12.07.2023.
//

import Foundation
import SQLite

extension TodoItem {
    public static func parse(sqlResponse: Any) -> TodoItem? {
        guard let sqlResponse = sqlResponse as? [String: Any?] else { return nil }

        guard let id = sqlResponse["id"] as? String,
              let text = sqlResponse["text"] as? String,
              let flag = sqlResponse["flag"] as? Bool,
              let creationDate = sqlResponse["creationDate"] as? Date else { return nil }

        var importance = Importance.reqular
        if let importanceType = sqlResponse["importanceType"] as? String {
            importance = Importance(rawValue: importanceType) ?? Importance.reqular
        }

        let deadline = sqlResponse["deadline"] as? Date
        let changeDate = sqlResponse["changeDate"] as? Date
        let hexCode = sqlResponse["hexCode"] as? String

        return TodoItem(id: id, text: text, importanceType: importance, deadline: deadline, flag: flag, creationDate: creationDate, changeDate: changeDate, hexCode: hexCode)

    }
}
