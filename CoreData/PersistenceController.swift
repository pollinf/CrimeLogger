//
//  PersistenceController.swift
//  CrimeLogger
//
//  Created by polina on 10.09.2024.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CriminalModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error)")
            }
        }
    }

    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
