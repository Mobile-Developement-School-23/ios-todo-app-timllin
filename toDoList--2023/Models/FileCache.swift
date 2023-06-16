//
//  FileCache.swift
//  toDoList--2023
//
//
//

import Foundation

struct FileCache{
    private(set) var toDoItemDict = [String: TodoItem]()
    
    public mutating func add(item: TodoItem) {
        if !toDoItemDict.keys.contains(item.getId()){
            toDoItemDict[item.getId()] = item
        } else {
            toDoItemDict.updateValue(item, forKey: item.getId())
        }
    }
    
    public mutating func delete(item: TodoItem) {
        if toDoItemDict.keys.contains(item.getId()){
            toDoItemDict.removeValue(forKey: item.getId())
        }
    }
    
    public func saveJSON(fileName: String) {
        let toDoItemList = toDoItemDict.map({$0.value}).map({$0.json})
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: toDoItemList, options: .prettyPrinted)
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
            try jsonData.write(to: fileURL)
        } catch {
            print(error)
        }
        
    }
    
    public mutating func loadJSON(fileName: String) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
            let jsonData = try Data(contentsOf: fileURL)
            guard let dictonary: [Any] = try JSONSerialization.jsonObject(with: jsonData) as? [Any] else {print("errorLoadJson"); return}
            for elem in dictonary{
                if let newItem = TodoItem.parse(json: elem){
                    toDoItemDict[newItem.getId()] = newItem
                }
            }
        }
        catch {
            print(error)
        }
    }
}

extension FileCache{
    public func saveCVS(fileName: String) {
        var csvData = "id,text,importanceType,deadline,flag,creationDate,changeDate\n"
        let toDoItemList = toDoItemDict.map({$0.value}).map({$0.csv})
        for itemString in toDoItemList{
            csvData.append(itemString)
        }
        do{
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
            try csvData.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    public mutating func loadCVS(fileName: String) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
            let dataString = try String(contentsOfFile: fileURL.path)
            
            let data: [String] = dataString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
            
            guard let headerCSV = data.first?.components(separatedBy: [","]) else {return }
            if headerCSV != ["id", "text", "importanceType", "deadline", "flag", "creationDate", "changeDate"]{
                return
            }
            
            for i in 1..<data.count{
                if let newItem = TodoItem.parse(csv: data[i]){
                    toDoItemDict[newItem.getId()] = newItem
                }
            }
        } catch {
            print(error)
        }
    }
}
