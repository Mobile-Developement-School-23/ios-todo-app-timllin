//
//  ToDoItemDTO.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 06.07.2023.
//

import Foundation
import UIKit

public struct TodoItemDTO: Codable {
    let id: String
    let text: String
    let importance: TodoItem.Importance
    let deadline: Int?
    let flag: Bool
    let hexCode: String?
    let creationDate: Int
    let changeDate: Int
    let deviceId: String

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline = "deadline"
        case flag = "done"
        case hexCode = "color"
        case creationDate = "created_at"
        case changeDate = "changed_at"
        case deviceId = "last_updated_by"
    }

    init(from todoItem: TodoItem) {
        self.id = todoItem.getId()
        self.text = todoItem.getText()
        self.importance = TodoItem.Importance(rawValue: todoItem.getImportanceTypeString())!
        self.deadline = todoItem.getDeadline().flatMap { Int($0.timeIntervalSince1970) }
        self.flag = todoItem.getFlag()
        self.hexCode = todoItem.getHexCode()
        self.creationDate = Int(todoItem.getCreationDate().timeIntervalSince1970)
        self.changeDate = Int((todoItem.getChangeDate() ?? todoItem.getCreationDate()).timeIntervalSince1970)
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        let baseImportance = try container.decode(String.self, forKey: .importance)
        var newImportance = TodoItem.Importance.reqular
        switch baseImportance {
        case "low":
            newImportance = TodoItem.Importance.unimportant
        case "basic":
            newImportance = TodoItem.Importance.reqular
        case "important":
            newImportance = TodoItem.Importance.important
        default:
            break
        }
        self.importance = newImportance
        self.deadline = try container.decodeIfPresent(Int.self, forKey: .deadline)
        self.flag = try container.decode(Bool.self, forKey: .flag)
        self.hexCode = try container.decodeIfPresent(String.self, forKey: .hexCode)
        self.creationDate = try container.decode(Int.self, forKey: .creationDate)
        self.changeDate = try container.decode(Int.self, forKey: .changeDate)
        self.deviceId = try container.decode(String.self, forKey: .deviceId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.text, forKey: .text)
        var newImportance: String = ""
        switch self.importance {
        case TodoItem.Importance.unimportant:
            newImportance = "low"
        case TodoItem.Importance.reqular:
            newImportance = "basic"
        case TodoItem.Importance.important:
            newImportance = "important"
        default:
            break
        }
        try container.encode(newImportance, forKey: .importance)
        try container.encodeIfPresent(self.deadline, forKey: .deadline)
        try container.encode(self.flag, forKey: .flag)
        try container.encodeIfPresent(self.hexCode, forKey: .hexCode)
        try container.encode(self.creationDate, forKey: .creationDate)
        try container.encodeIfPresent(self.changeDate, forKey: .changeDate)
        try container.encode(self.deviceId, forKey: .deviceId)
    }
}
