//
//  Properties.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import Foundation

enum ServerEnvironment: String {
    case dev = "https://api.chess.com_temp"// added '_temp' just to make it unique for now
    case prod = "https://api.chess.com"
}

class Properties  {
    static var environment: ServerEnvironment {
        #if DEBUG
        //return .dev
        return .prod
        #else
        return .prod
        #endif
    }
}
