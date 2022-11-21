//
//  Codable+Extension.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 04/06/2019,23.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation


extension Encodable {
    
    func persist() {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return
        }
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(String(describing: Self.self)) {
            print(url)
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
    }
}

extension Decodable {
    static func fetch() -> Self? {
        
        let decoder = JSONDecoder()
        
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(String(describing: Self.self)) {
            print(url)
            if let data = FileManager.default.contents(atPath: url.path)  {
                let model = try? decoder.decode(Self.self, from: data)
                return model
            }
        }
        return nil
    }
}
