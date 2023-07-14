//
//  ToDoItem+CoreData.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 13.07.2023.
//

import Foundation
import CoreData

extension TodoItem {
    public static func parse(coreDataResponse: NSManagedObject) -> TodoItem? {
        guard let id = coreDataResponse.value(forKey: "id") as? String,
              let text = coreDataResponse.value(forKey: "text") as? String,
              let flag = coreDataResponse.value(forKey: "flag") as? Bool,
              let creationDate = coreDataResponse.value(forKey: "creationDate") as? Date else { return nil}

        var importance = Importance.reqular
        if let importanceType = coreDataResponse.value(forKey: "importanceType") as? String {
            importance = Importance(rawValue: importanceType) ?? Importance.reqular
        }
        let deadline = coreDataResponse.value(forKey:"deadline") as? Date
        let changeDate = coreDataResponse.value(forKey: "changeDate") as? Date
        let hexCode = coreDataResponse.value(forKey: "hexCode") as? String

        return TodoItem(id: id, text: text, importanceType: importance, deadline: deadline, flag: flag, creationDate: creationDate, changeDate: changeDate, hexCode: hexCode)
    }
}
