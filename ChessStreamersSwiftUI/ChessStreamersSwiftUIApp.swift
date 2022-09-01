//
//  ChessStreamersSwiftUIApp.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import SwiftUI

@main
struct ChessStreamersSwiftUIApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainView(/*model: MainViewModel()*/)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
