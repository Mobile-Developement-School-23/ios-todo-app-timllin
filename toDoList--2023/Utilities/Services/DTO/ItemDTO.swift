//
//  ItemDTO.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 06.07.2023.
//

import Foundation

struct ItemDTO: Codable {
    let status: String?
    let element: TodoItemDTO
    let revision: Int32?

    init(status: String? = nil, element: TodoItemDTO, revision: Int32? = nil) {
        self.status = status
        self.element = element
        self.revision = revision
    }
}
