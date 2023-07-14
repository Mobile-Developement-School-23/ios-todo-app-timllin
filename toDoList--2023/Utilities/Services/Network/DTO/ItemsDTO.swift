//
//  ServerAnswer.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 06.07.2023.
//

import Foundation

struct ItemsDTO: Codable {
    let status: String?
    let list: [TodoItemDTO]
    let revision: Int32?

    init(status: String? = nil, list: [TodoItemDTO], revision: Int32? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}
