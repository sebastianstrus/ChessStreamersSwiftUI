//
//  Streamer.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import CoreData
import Foundation

extension CodingUserInfoKey {
  static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(Streamer)
class Streamer: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case username
        case avatarUrl = "avatar"
        case url
        case isLive = "is_live"
    }
        
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
                    throw DecoderConfigurationError.missingManagedObjectContext
                }
                
                self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        self.url = try container.decode(String.self, forKey: .url)
        self.isLive = try container.decode(Bool.self, forKey: .isLive)
      }
}


