//
//  MainViewModel.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {

    @Published var streamers: [Streamer] = []
    private var streamersCancellable: AnyCancellable?

    init() {
        getStreamers()
    }

    private func getStreamers() {
        self.streamersCancellable = StreamersAPIService.getStreamers()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion
                {
                case .failure(let error):
                    print("Error fetching streamers: \(error.localizedDescription)")
                    // TODO: get streamers from CoreData
                    
                case .finished:
                    print("Finished")
                    break
                }
            }, receiveValue: { [unowned self] fetchedObject in
                streamers = fetchedObject["streamers"] ?? []
            })
    }
}
