//
//  DataController.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-09-01.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "ChessStreamersSwiftUI")
    
    init() {
        print("Init")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
