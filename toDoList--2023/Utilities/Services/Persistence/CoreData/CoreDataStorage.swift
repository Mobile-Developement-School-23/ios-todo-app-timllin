//
//  CoreDataStorage.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 13.07.2023.
//

import Foundation
import CoreData

class CoreDataStorage {
    static let shared = CoreDataStorage()

    private init() {
    }

    private lazy var persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDatabase")
        container.loadPersistentStores(completionHandler: {_, error in _ = error.map { fatalError("Unresolved error \($0)")}
        })
        return container
    }()

    private var mainContext: NSManagedObjectContext {
        return persistenceContainer.viewContext
    }

    private func backgroundContext() -> NSManagedObjectContext {
        return persistenceContainer.newBackgroundContext()
    }

}

extension CoreDataStorage {
    public func saveContext() {
        let context = CoreDataStorage.shared.mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }

    public func load() -> [NSManagedObject] {
        let context = CoreDataStorage.shared.mainContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print(error)
            return []
        }
    }

    public func insert(of item: TodoItem) {
        let context = CoreDataStorage.shared.backgroundContext()
        let entity = Item.entity()
        let cdItem = Item(entity: entity, insertInto: context)
        context.perform {
            do {
                cdItem.setValue(item.getId(), forKeyPath: "id")
                cdItem.setValue(item.getText(), forKeyPath: "text")
                cdItem.setValue(item.getFlag(), forKeyPath: "flag")
                cdItem.setValue(item.getDeadline(), forKeyPath: "deadline")
                cdItem.setValue(item.getImportanceTypeString(), forKeyPath: "importanceType")
                cdItem.setValue(item.getCreationDate(), forKeyPath: "creationDate")
                cdItem.setValue(item.getChangeDate(), forKeyPath: "changeDate")
                cdItem.setValue(item.getHexCode(), forKeyPath: "hexCode")
                try context.save()
            } catch {
                print(error)
            }
        }
    }

    public func update(of item: TodoItem) {
        let context = CoreDataStorage.shared.backgroundContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.getId())
        do {
            let data = try context.fetch(fetchRequest)
            guard data.count == 1, let cdItem = data.first else { return }
            cdItem.setValue(item.getId(), forKeyPath: "id")
            cdItem.setValue(item.getText(), forKeyPath: "text")
            cdItem.setValue(item.getFlag(), forKeyPath: "flag")
            cdItem.setValue(item.getDeadline(), forKeyPath: "deadline")
            cdItem.setValue(item.getImportanceTypeString(), forKeyPath: "importanceType")
            cdItem.setValue(item.getCreationDate(), forKeyPath: "creationDate")
            cdItem.setValue(item.getChangeDate(), forKeyPath: "changeDate")
            cdItem.setValue(item.getHexCode(), forKeyPath: "hexCode")
            try context.save()
        } catch {
            print(error)
        }
    }

    public func delete(of item: TodoItem) {
        let context =  CoreDataStorage.shared.backgroundContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.getId())
        do {
            let data = try context.fetch(fetchRequest)
            guard data.count == 1, let cdItem = data.first else { return }
            context.delete(cdItem)
            try context.save()
        } catch {
            print(error)
        }
    }
}
