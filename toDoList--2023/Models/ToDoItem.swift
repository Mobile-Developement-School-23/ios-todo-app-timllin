//
//  ToDoItem.swift
//  toDoList--2023
//
//
//

import Foundation

public struct TodoItem{
    private let id: String
    private let text: String
    private let importanceType: Importance
    private let deadline: Date?
    private let flag: Bool
    private let creationDate: Date
    private let changeDate: Date?
    
    init(id: String = UUID().uuidString, text: String, importanceType: Importance, deadline: Date? = nil, flag: Bool, creationDate: Date = Date(), changeDate: Date? = nil) {
        self.id = id
        self.text = text
        self.importanceType = importanceType
        self.deadline = deadline
        self.flag = flag
        self.creationDate = creationDate
        self.changeDate = changeDate
    }
    
    enum Importance: String {
        case unimportant
        case reqular
        case important
    }
}

extension TodoItem{
    public static func parse(json: Any) -> TodoItem? {

        guard let jsonDict = json as? [String: Any] else {return nil}
    
        guard let id = jsonDict["id"] as? String,
              let text = jsonDict["text"] as? String,
              let flag = jsonDict["flag"] as? Bool,
              let creationDateTimeStamp = jsonDict["creationDate"] as? Double else {return nil}
    
        let creationDate = Date(timeIntervalSince1970: creationDateTimeStamp)
        
        var importanceType: Importance = Importance.reqular
        if let importanceTypeRawValue = jsonDict["importanceType"] as? String {
            importanceType = Importance(rawValue: importanceTypeRawValue) ?? Importance.reqular
        }
        
        
        let deadlineTimeStamp = jsonDict["deadline"] as? Double
        let changeDateTimeStamp = jsonDict["changeDate"] as? Double
        
        let deadline = deadlineTimeStamp.map { Date(timeIntervalSince1970: $0) }
        let changeDate =  changeDateTimeStamp.map { Date(timeIntervalSince1970: $0) }
        
        
        let toDoItem = TodoItem(id: id,
                                text: text,
                                importanceType: importanceType,
                                deadline: deadline,
                                flag: flag,
                                creationDate: creationDate,
                                changeDate: changeDate)
        return toDoItem
    }
    
    public var json: Any {
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "flag": flag,
            "creationDate": creationDate.timeIntervalSince1970
        ]
        
        switch importanceType{
        case .reqular:
            break
        default:
            dict["importanceType"] = importanceType.rawValue
        }
        
        if let deadline = deadline {
            dict["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let changeDate = changeDate {
            dict["changeDate"] = changeDate.timeIntervalSince1970
        }
        
        return dict
    }
}

extension TodoItem{
    public static func parse(csv: String) -> TodoItem? {
        let castTypeDict: [String: String] = ["id" : "String",
                                              "text" : "String",
                                              "importanceType": "String",
                                              "deadline": "Double",
                                              "flag": "Bool",
                                              "creationDate": "Double",
                                              "changeDate" : "Double"]
        
        let headerCSV = ["id", "text", "importanceType", "deadline", "flag", "creationDate", "changeDate"]
        
        let itemList = csv.components(separatedBy: [","])
        if itemList.count != 7{
            return nil
        }
                
        let itemDict: [String: String] = Dictionary(uniqueKeysWithValues: zip(headerCSV, itemList))
        
        let newitemDict: [String: Any] = itemDict.reduce([:]) { (partialResult: [String: Any], tuple: (key: String, value: Any)) in
            var result = partialResult
            if tuple.value as? String != "" {
                if let castType = castTypeDict[tuple.key] {
                    switch castType{
                    case "Double":
                        if let value = tuple.value as? String {
                            result[tuple.key] = Double(value)
                        }
                    case "Bool":
                        if let value = tuple.value as? String {
                            result[tuple.key] = Bool(value)
                        }
                    case "String":
                        result[tuple.key] = tuple.value
                    default:
                        break
                    }
                }
            }
            return result
        }
        return TodoItem.parse(json: newitemDict)
    }
    
    public var csv: String {
        let csvId = id
        let csvText = text
        let csvflag = flag
        let csvCreationDate = String(creationDate.timeIntervalSince1970)
        
        var csvImportanceType = ""
        switch importanceType{
        case .reqular:
            break
        default:
            csvImportanceType = importanceType.rawValue
        }
        
        var csvDeadline = ""
        if let deadline = deadline {
            csvDeadline = String(deadline.timeIntervalSince1970)
        }
        
        var csvChangeDate = ""
        if let changeDate = changeDate {
            csvChangeDate = String(changeDate.timeIntervalSince1970)
        }
        let itemString = "\(csvId),\(csvText),\(csvImportanceType),\(csvDeadline),\(csvflag),\(csvCreationDate),\(csvChangeDate)\n"
        return itemString
    }
}

extension TodoItem{
    public func getId() -> String {
        return id
    }
    
    public func getText() -> String {
        return text
    }
    
    public func getImportanceTypeString() -> String {
        return importanceType.rawValue
    }
    
    public func getDeadline() -> Date? {
        return deadline
    }
    
    public func getFlag() -> Bool {
        return flag
    }
    
    public func getCreationDate() -> Date {
        return creationDate
    }
    
    public func getChangeDate() -> Date? {
        return changeDate
    }
}

