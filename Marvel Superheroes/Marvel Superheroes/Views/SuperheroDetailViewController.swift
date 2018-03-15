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
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let superhero = self.superhero else {
            return
        }
        self.title = superhero.name
        
        self.heroImageView.image = superheroImage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemSegue" {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            
            let itemDetailViewController = segue.destination as! ItemDetailViewController
            switch indexPath.section {
            case 0:
                itemDetailViewController.item = superhero?.comics[indexPath.row]
            case 1:
                itemDetailViewController.item = superhero?.events[indexPath.row]
            case 2:
                itemDetailViewController.item = superhero?.stories[indexPath.row]
            case 3:
                itemDetailViewController.item = superhero?.series[indexPath.row]
            default:
                return 
            }
        }
    }
}

extension SuperheroDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let superhero = superhero else {
            return 0
        }
        switch section {
        case 0:
            return superhero.comics.count > 3 ? 3 : superhero.comics.count
        case 1:
            return superhero.events.count > 3 ? 3 : superhero.events.count
        case 2:
            return superhero.stories.count > 3 ? 3 : superhero.stories.count
        case 3:
            return superhero.series.count > 3 ? 3 : superhero.series.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = superhero?.comics[indexPath.row].name
        case 1:
            cell.textLabel?.text = superhero?.events[indexPath.row].name
        case 2:
            cell.textLabel?.text = superhero?.stories[indexPath.row].name
        case 3:
            cell.textLabel?.text = superhero?.series[indexPath.row].name
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Comics"
        case 1:
            return "Events"
        case 2:
            return "Stories"
        case 3:
            return "Series"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
