//
//  NetworkingService.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 04.07.2023.
//

import Foundation

protocol NetworkingService {

    func getDataFromServer() async throws -> [TodoItem]

    func updateDataOnServer(items: [TodoItem]) async throws -> [TodoItem]

    func getItem(with item: TodoItem) async throws

    func postItem(with item: TodoItem) async throws

    func putItem(with item: TodoItem) async throws

    func deleteItem(with item: TodoItem) async throws
}
