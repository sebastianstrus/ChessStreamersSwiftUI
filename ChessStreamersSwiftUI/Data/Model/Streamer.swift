//
//  Streamer.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import CoreData
import Foundation

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(Streamer)
class Streamer: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        //case id
        case username
        case avatarUrl = "avatar"
        case url
        case isLive = "is_live"
    }
    
    public static var managedObjectContext: NSManagedObjectContext?
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
                    throw DecoderConfigurationError.missingManagedObjectContext
                }
                
                self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        //self.id = try container.decode(UUID.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        self.url = try container.decode(String.self, forKey: .url)
        self.isLive = try container.decode(Bool.self, forKey: .isLive)
      }
    

}

