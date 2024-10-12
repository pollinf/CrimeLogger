//
//  CrimeLoggerApp.swift
//  CrimeLogger
//
//  Created by polina on 09.09.2024.
//

import SwiftUI
import CoreData

@main
struct CrimeLoggerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


