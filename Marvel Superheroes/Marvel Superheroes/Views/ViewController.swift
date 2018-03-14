//
//  ViewController.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 13/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var superheros: [Superhero]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.superheros = [Superhero]()
        let baseUrl = "https://gateway.marvel.com/v1/public/characters"
        let apiKey = "b56deb618cadad85723376a7c4956743"
        let privateKey = "a9420be765d8255c52a6896f4699d3e59a1f8364"
        let networkController = NetworkController(baseUrl: baseUrl, apiKey: apiKey, privateKey: privateKey)
        networkController.getSuperheroes(limit: 20, offset: 0) { (superheroData, error) in
            
            do {
                if let superheroJSON = try JSONSerialization.jsonObject(with: superheroData!, options: []) as? [String: Any] {
                    guard let dataArray = superheroJSON["data"] as? [String: Any] else {
                        return
                    }
                    guard let superheroArray = dataArray["results"] as? [[String: Any]]  else {
                        return
                    }
                    for superhero:[String: Any] in superheroArray {
                        if let hero = Superhero(json: superhero) {
                            self.superheros?.append(hero)
                        }
                    }
                    print(self.superheros)
                } else {
                    self.showError(error: error)
                }
            } catch {
                self.showError(error: error)
            }

        }
        
    }

    func showError(error: Error?) {
        var messageToShow:String = ""
        guard error == nil else {
            guard let errorMessage = error?.localizedDescription else {
                messageToShow = "Error Occured"
                return
            }
            messageToShow = errorMessage
            return
        }
        let alertController = UIAlertController(title: "Error", message:
            messageToShow, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: true, completion: nil)
    }
}

