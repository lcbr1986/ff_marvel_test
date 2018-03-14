//
//  SuperheroTableViewCell.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 14/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class SuperheroTableViewCell: UITableViewCell {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
