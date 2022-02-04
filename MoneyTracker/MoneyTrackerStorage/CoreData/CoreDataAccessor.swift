//
//  CoreDataAccessor.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 03.02.2022.
//

import Foundation
import CoreData

class CoreDataAccessor {
    
    // MARK: - Properties
    
    private let storageName: String
    private let storeURL: URL?
    
    // MARK: - Dependencies
    
    // MARK: - Life cycle
    
    init(storageName: String, storeURL: URL?) {
        self.storageName = storageName
        self.storeURL = storeURL
    }
    
    // MARK: - Persistence container
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer
        do {
            let model = try createManagedObjectModel()
            container = NSPersistentContainer(name: storageName, managedObjectModel: model)
        } catch {
            print("Failed to create NSPersistentContainer with NSManagedObjectModel")
            container = NSPersistentContainer(name: storageName)
        }
        if let storeURL = storeURL {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]
        }
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func createManagedObjectModel() throws -> NSManagedObjectModel {
        let bundle = Bundle(for: type(of: self))
        guard let modelURL = bundle.url(forResource: storageName, withExtension: "momd") else {
            throw CreationError.canNotCreateModelURL
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CreationError.canNotCreateModel
        }
        return model
    }
    
    // MARK: - Context
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Errors
    
    enum CreationError: Error {
        case canNotCreateModelURL
        case canNotCreateModel
    }
}
