//
//  DetailView.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import SwiftUI

struct DetailView: View {

    var streamer: Streamer

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: streamer.avatarUrl),
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 180, maxHeight: 180)
            }, placeholder: {
                ProgressView()
            })
            .padding()

            Text(streamer.username)
                .font(.system(size: 28))
                .padding()

            Text(streamer.isLive ? "Available" : "Unavailable")
                .foregroundColor(streamer.isLive ? .green : .red)
                .font(.system(size: 22))
                .padding()

            VStack {
                Text("Visit")
                Link("\(streamer.url)", destination: URL(string: streamer.url)!)
            }.padding()

            Spacer()
        }
    }
}

