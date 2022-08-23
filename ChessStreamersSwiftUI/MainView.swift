//
//  MainView.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import SwiftUI

struct MainView: View {

    @StateObject var model: MainViewModel

    let columns: [GridItem] = Array(repeating: .init(.flexible()),
                                    count: Device.IS_IPAD ? 8 : 4)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(model.streamers, id: \.self) { item in
                        NavigationLink(destination: DetailView(streamer: item)) {
                            AsyncImage(url: URL(string: item.avatarUrl),
                                       content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 100, maxHeight: 100)
                            }, placeholder: {
                                ProgressView()
                            })
                        }
                    }
                }
            }.navigationTitle("Chess Streamers")
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

