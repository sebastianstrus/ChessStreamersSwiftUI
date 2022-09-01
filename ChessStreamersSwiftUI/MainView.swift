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
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(streamers, id: \.self) { item in
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
                
                
                Button("Add") {
                    let streamer = Streamer(context: moc)
                    streamer.id = UUID()
                    streamer.username = "Sebastian"
                    streamer.isLive = true
                    streamer.avatarUrl = "https://scontent-arn2-2.xx.fbcdn.net/v/t31.18172-8/11700821_10207249342662960_1428027601653512940_o.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=jiTWFXA5IUgAX8krDCj&_nc_ht=scontent-arn2-2.xx&oh=00_AT93DrCrwIYhszF2PKYVyxuzih-Z3XPPKdBEseH0cThz3A&oe=6334EDE2"
                    streamer.url = "https://www.facebook.com/sebastian.strus"
                    try? moc.save()
                }
                
            }.navigationTitle("Chess Streamers")
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

