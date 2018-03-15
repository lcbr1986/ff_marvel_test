//
//  ItemDetailViewController.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 15/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var item: Items?
    override func viewDidLoad() {
        super.viewDidLoad()

        setDetails()
        
        guard let item = self.item else {
            return
        }
        let networkController = NetworkController(baseUrl: item.resourceURI.replacingOccurrences(of: "http", with: "https"))
        networkController.getItemDetails { (itemData, error) in
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
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                            return
                    }
                    self.item = Items(name: title, resourceURI: resourceURI, description: description)
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.setDetails()
                    }
                } else {
                    self.descriptionLabel.text = error?.localizedDescription
                }
            } catch {
                self.descriptionLabel.text = error.localizedDescription
            }
        }
    }
    
    func setDetails() {
        guard let item = self.item else {
            return
        }
        self.title = item.name
        self.titleLabel.text = item.name
        self.descriptionLabel.text = item.description
    }
}
