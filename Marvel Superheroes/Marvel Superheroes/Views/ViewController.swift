//
//  ViewController.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 13/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var superheros: [Superhero] = [Superhero]()
    var currentOffset: Int = 0
    var totalSuperheros: Int = 0
    var imageCache:[String: UIImage] = [String: UIImage]()
    let defaults = UserDefaults.standard
    
    var searchTerm = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSuperheros()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func resetList() {
        currentOffset = 0
        totalSuperheros = 0
        superheros = [Superhero]()
        searchTerm = ""
    }
    
    func getSuperheros() {
        let networkController = NetworkController()
        if searchTerm == "" {
            networkController.getSuperheroes(limit: 20, offset: self.currentOffset) { (superheroData, error) in
                self.updateValues(superheroData: superheroData, error: error)
            }
        } else {
            networkController.getSuperherosByName(searchText: searchTerm, limit: 20, offset: self.currentOffset) { (superheroData, error) in
                self.updateValues(superheroData: superheroData, error: error)
            }
        }
    }
    
    func updateValues(superheroData: Data?, error: Error?) {
        SuperheroParser.decodeSuperheros(superheroData: superheroData, error: error, completionHandler: { (arg0, closureError) in
            if closureError != nil {
                self.showError(error: closureError)
            } else {
                guard let (superheros, total) = arg0 else {
                    return
                }
                self.superheros.append(contentsOf: superheros)
                self.totalSuperheros = total
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
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
    
//    func decodeSuperheros(superheroData: Data?, error: Error?) {
//        do {
//            if let superheroJSON = try JSONSerialization.jsonObject(with: superheroData!, options: []) as? [String: Any] {
//                guard let dataArray = superheroJSON["data"] as? [String: Any] else {
//                    return
//                }
//                guard let superheroArray = dataArray["results"] as? [[String: Any]],
//                    let total = dataArray["total"] as? Int else {
//                        return
//                }
//                self.totalSuperheros = total
//                for superhero:[String: Any] in superheroArray {
//                    if let hero = Superhero(json: superhero) {
//                        self.superheros.append(hero)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            } else {
//                self.showError(error: error)
//            }
//        } catch {
//            self.showError(error: error)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            let superhero:Superhero = superheros[indexPath.row]
            let superheroDetailViewController = segue.destination as! SuperheroDetailViewController
            superheroDetailViewController.superhero = superhero
            superheroDetailViewController.superheroImage = self.imageCache[superhero.name]
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentOffset < self.totalSuperheros {
            return superheros.count + 1
        }
        return superheros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.currentOffset < self.totalSuperheros && indexPath.row == self.superheros.count {
            let cell: SuperheroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! SuperheroTableViewCell
            return cell
        }
        
        let cell: SuperheroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "superheroCell", for: indexPath) as! SuperheroTableViewCell
        let currentSuperhero = superheros[indexPath.row]
        cell.titleLabel.text = currentSuperhero.name
        
        let favoriteSuperhero = defaults.string(forKey: Constants.favoriteKey)
        
        if favoriteSuperhero == currentSuperhero.name {
            cell.backgroundColor = .yellow
        } else {
            cell.backgroundColor = .clear   
        }
        
        cell.heroImageView.image = nil
        if let heroImage = imageCache[currentSuperhero.name] {
            cell.heroImageView.image = heroImage
        } else {
            guard let imagePath = currentSuperhero.thumbnail?.path,
                let imageExtension = currentSuperhero.thumbnail?.imageExtension else {
                    return cell
            }
            let imageUrl: String = "\(String(describing: imagePath)).\(String(describing: imageExtension))"
            let httpsImageUrl = imageUrl.replacingOccurrences(of: "http", with: "https")
            guard let url = URL(string: httpsImageUrl) else {
                return cell
            }
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let heroImage = UIImage(data: data)
                        cell.heroImageView.image = heroImage
                        self.imageCache[currentSuperhero.name] = heroImage
                    }
                } else {
                    cell.heroImageView.image = nil
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.currentOffset < self.totalSuperheros && indexPath.row == self.superheros.count {
            self.currentOffset += 20
            getSuperheros()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        resetList()
        guard let searchTerm = searchBar.text else {
            return
        }
        self.searchTerm = searchTerm.replacingOccurrences(of: " ", with: "%20")
        getSuperheros()
    }
}

