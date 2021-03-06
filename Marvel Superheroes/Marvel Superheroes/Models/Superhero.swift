//
//  Superhero.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 13/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

struct Superhero {
    let id: Int
    let name: String
    let thumbnail: Thumbnail?
    var comics: [Items]
    var events: [Items]
    var stories: [Items]
    var series: [Items]
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
        let thumbnailData = json["thumbnail"] as? [String: Any],
            let path = thumbnailData["path"] as? String,
            let imageExtension = thumbnailData["extension"] as? String else {
                return nil
        }
        self.id = id
        self.name = name
        let thumbnail = Thumbnail(path: path, imageExtension: imageExtension)
        self.thumbnail = thumbnail
        
        self.comics = Items.getItemsData(json: json, itemsKey: "comics")
        self.events = Items.getItemsData(json: json, itemsKey: "events")
        self.stories = Items.getItemsData(json: json, itemsKey: "stories")
        self.series = Items.getItemsData(json: json, itemsKey: "series")
        
    }
    
}
