//
//  URLSession.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 04.07.2023.
//

import Foundation

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            var dataTask: URLSessionDataTask?
            let onCancel = { dataTask?.cancel() }

            return try await withTaskCancellationHandler(
                handler: {
                    onCancel()
                },
                operation: {
                    try await withCheckedThrowingContinuation { continuation in
                        dataTask = self.dataTask(with: request) { data, response, error in
                            guard let data = data, let response = response else {
                                let error = error ?? URLError(.badServerResponse)
                                return continuation.resume(throwing: error)
                            }

                            continuation.resume(returning: (data, response))
                        }
                        dataTask?.resume()
                    }
                }
            )
        }
}
