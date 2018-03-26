//
//  SuperheroParser.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 26/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import Foundation

struct SuperheroParser {
    
    static func decodeSuperheros(superheroData: Data?, error: Error?, completionHandler: @escaping (([Superhero], Int)?, Error?) -> Void) {
        do {
            if let superheroJSON = try JSONSerialization.jsonObject(with: superheroData!, options: []) as? [String: Any] {
                guard let dataArray = superheroJSON["data"] as? [String: Any] else {
                    return
                }
                guard let superheroArray = dataArray["results"] as? [[String: Any]],
                    let total = dataArray["total"] as? Int else {
                        return
                }
                var superheros = [Superhero]()
                for superhero:[String: Any] in superheroArray {
                    if let hero = Superhero(json: superhero) {
                        superheros.append(hero)
                    }
                }
                completionHandler((superheros, total), nil)
            } else {
                completionHandler(nil, error)
            }
        } catch {
            completionHandler(nil, error)
        }
    }
}
