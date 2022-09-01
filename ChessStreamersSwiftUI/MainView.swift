//
//  MainView.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import SwiftUI

struct MainView: View {

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var streamers: FetchedResults<Streamer>
    
    @StateObject var model: MainViewModel

    let columns: [GridItem] = Array(repeating: .init(.flexible()),
                                    count: Device.IS_IPAD ? 8 : 4)

    var body: some View {
        print("Streamers fetched from internet: \(model.streamers.count)")
        print("Streamers saved in Core Data: \(streamers.count)")
        return NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(model.streamers, id: \.self) { item in
                            NavigationLink(destination: DetailView(streamer: item)) {
                                AsyncImage(url: URL(string: item.avatarUrl ?? ""),
                                           content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                }, placeholder: {
                                    ProgressView()
                                })
                            }
                        }
                    }
                }.navigationTitle("Chess Streamers")
                
                
                Button("Add") {
                    let streamer = Streamer(context: moc)
                    streamer.id = UUID()
                    streamer.username = "Sebastian"
                    streamer.isLive = true
                    streamer.url = "https://www.facebook.com/sebastian.strus"
                    streamer.avatarUrl = "https://sebastianstrus.github.io/img/portrait.jpg"
                    try? moc.save()
                }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

