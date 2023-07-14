//
//  DefaultNetworkingService.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 04.07.2023.
//

import Foundation

class DefaultNetworkingService: NetworkingService {

    private let token = "palaemonidae"
    private let baseURL = "https://beta.mrdekk.ru/todobackend"

    private(set) var revision: Int32 = 0

    private var isDirty = false

    private let urlSession = URLSession.shared

    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    func getDataFromServer() async throws -> [TodoItem] {
        guard let url = URL(string: "\(self.baseURL)/list") else { throw NetworkError.badRequest }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)"]

        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 {
                throw NetworkError.serverNotFound
            }
        }

        let dataDecoded = try jsonDecoder.decode(ItemsDTO.self, from: data)
        if let newRevision = dataDecoded.revision {
            revision = newRevision
        }
        return dataDecoded.list.map { TodoItem.parse(todoItemDTO: $0) }
    }

    func updateDataOnServer(items: [TodoItem]) async throws -> [TodoItem] {
        guard let url = URL(string: "\(self.baseURL)/list") else { throw NetworkError.badRequest }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)",
                                       "X-Last-Known-Revision": "\(self.revision)"]

        let listTodoItem = ItemsDTO(list: items.map({ TodoItemDTO(from: $0) }))

        request.httpBody = try jsonEncoder.encode(listTodoItem)

        let (data, response) = try await urlSession.data(for: request)
        print(response)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 {
                dirtyPost()
                throw NetworkError.serverNotFound
            } else if response.statusCode == 400 {
                dirtyPost()
                throw NetworkError.badRequest
            }
        }

        let dataDecoded = try jsonDecoder.decode(ItemsDTO.self, from: data)

        if let newRevision = dataDecoded.revision {
            revision = newRevision
        }

        return dataDecoded.list.map { TodoItem.parse(todoItemDTO: $0) }
    }

    func getItem(with item: TodoItem) async throws {
        guard let url = URL(string: "\(self.baseURL)/list/\(item.getId())") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)"]

        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse {
            if response.statusCode == 404 {
                throw NetworkError.itemNotFound
            } else if response.statusCode == 500 {
                throw NetworkError.serverNotFound
            }
        }

        let dataDecoded = try jsonDecoder.decode(ItemDTO.self, from: data)

        if let newRevision = dataDecoded.revision {
            revision = newRevision
        }
    }

    func postItem(with item: TodoItem) async throws {
        guard let url = URL(string: "\(self.baseURL)/list") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)",
                                       "X-Last-Known-Revision": "\(self.revision)"]

        let todoItem = TodoItemDTO(from: item)
        let element = ItemDTO(element: todoItem)

        request.httpBody = try jsonEncoder.encode(element)

        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                dirtyPost()
                throw NetworkError.badRequest
            } else if response.statusCode == 500 {
                dirtyPost()
                throw NetworkError.serverNotFound
            }
        }

        let dataDecoded = try jsonDecoder.decode(ItemDTO.self, from: data)

        if let newRevision = dataDecoded.revision {
            revision = newRevision
        }
    }

    func putItem(with item: TodoItem) async throws {
        guard let url = URL(string: "\(self.baseURL)/list/\(item.getId())") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)",
                                       "X-Last-Known-Revision": "\(self.revision)"]

        let todoItem = TodoItemDTO(from: item)
        let element = ItemDTO(element: todoItem)

        request.httpBody = try jsonEncoder.encode(element)

        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                dirtyPost()
                throw NetworkError.badRequest
            } else if response.statusCode == 404 {
                throw NetworkError.itemNotFound
            } else if response.statusCode == 500 {
                dirtyPost()
                throw NetworkError.serverNotFound
            }
        }

        let dataDecoded = try jsonDecoder.decode(ItemDTO.self, from: data)

        if let newRevision = dataDecoded.revision {
            revision = newRevision
        }
    }

    func deleteItem(with item: TodoItem) async throws {
        guard let url = URL(string: "\(self.baseURL)/list/\(item.getId())") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)",
                                       "X-Last-Known-Revision": "\(self.revision)"]

        let todoItem = TodoItemDTO(from: item)
        let element = ItemDTO(element: todoItem)

        request.httpBody = try jsonEncoder.encode(element)

        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                dirtyPost()
                throw NetworkError.badRequest
            } else if response.statusCode == 404 {
                throw NetworkError.itemNotFound
            } else if response.statusCode == 500 {
                dirtyPost()
                throw NetworkError.serverNotFound
            }
        }

        let dataDecoded = try jsonDecoder.decode(ItemDTO.self, from: data)

        if let newRevision = dataDecoded.revision {
            revision = newRevision
        }
    }
}

extension DefaultNetworkingService {
    public func getRevision() -> Int32 {
        return revision
    }

    public func setIsDirty(_ bool: Bool) {
        self.isDirty = bool
    }

    public func getIsDirty() -> Bool {
        return self.isDirty
    }

    private func dirtyPost() {
        isDirty = true
        // NotificationCenter.default.post(name: .idDirtyNetwork, object: nil)
    }
}

enum NetworkError: Error {
    case wrongUrl
    case badRequest
    case itemNotFound
    case serverNotFound
}
