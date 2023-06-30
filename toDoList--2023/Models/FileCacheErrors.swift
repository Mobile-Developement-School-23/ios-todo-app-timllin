//
//  FileCacheErrors.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 19.06.2023.
//

import Foundation

enum FileCacheErrors: Error {
    case cannotFindFile
    case unparsableData
}
