//
//  Items.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 15/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

struct Items {
    let name: String
    let resourceURI: String
    let description: String
    
    init(name: String, resourceURI: String, description: String = "") {
        self.name = name
        self.resourceURI = resourceURI
        self.description = description
    }
    
    static func getItemsData(json: [String: Any], itemsKey: String) -> [Items] {
        var itemsObject = [Items]()
        if let itemsData = json[itemsKey] as? [String: Any], let items = itemsData["items"] as? [[String: Any]] {
            for item in items {
                if let itemName = item["name"] as? String, let itemResourceURI = item["resourceURI"] as? String{
                    var finalItem = Items(name: itemName, resourceURI: itemResourceURI)
                    if let itemDescription = item["description"] as? String {
                        finalItem = Items(name: itemName, resourceURI: itemResourceURI, description: itemDescription)
                    }
                    
                    itemsObject.append(finalItem)
                }
            }
        }
        return itemsObject
    }
}
