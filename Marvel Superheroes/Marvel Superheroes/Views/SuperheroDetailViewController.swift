//
//  SuperheroDetailViewController.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 14/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class SuperheroDetailViewController: UIViewController {
    
    var superhero: Superhero?
    var superheroImage: UIImage?

    @IBOutlet weak var heroImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let superhero = self.superhero else {
            return
        }
        self.title = superhero.name
        
        self.heroImageView.image = superheroImage
    }

}
