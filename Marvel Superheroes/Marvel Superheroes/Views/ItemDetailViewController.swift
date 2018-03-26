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
        let networkController = NetworkController()
        networkController.getItemDetails(baseUrl: item.resourceURI.replacingOccurrences(of: "http", with: "https")) { (itemData, error) in
            ItemParser.decodeItems(itemData: itemData, error: error, completionHandler: { (item, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                if error != nil {
                    self.descriptionLabel.text = error?.localizedDescription
                } else {
                    self.item = item
                    
                    DispatchQueue.main.async {
                        self.setDetails()
                    }
                }
            })
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
