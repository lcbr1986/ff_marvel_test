//
//  ItemParser.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 26/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import Foundation

struct ItemParser {
    static func decodeItems(itemData: Data?, error: Error?, completionHandler: @escaping (Items?, Error?) -> Void) {
        do {
            if let itemJson = try JSONSerialization.jsonObject(with: itemData!, options: []) as? [String: Any] {
                guard let dataArray = itemJson["data"] as? [String: Any],
                    let itemArray = dataArray["results"] as? [[String: Any]] else {
                        return
                }
                let itemDictionary: [String: Any] = itemArray[0]
                guard let title = itemDictionary["title"] as? String,
                    let resourceURI = itemDictionary["resourceURI"] as? String,
                    let description = itemDictionary["description"] as? String else {
                        return
                }
                let item = Items(name: title, resourceURI: resourceURI, description: description)
                
                completionHandler(item, nil)
            } else {
                completionHandler(nil, error)
            }
        } catch {
            completionHandler(nil, error)
        }
    }
}
