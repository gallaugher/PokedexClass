//
//  DetailViewController.swift
//  PokedexClass
//
//  Created by John Gallaugher on 11/7/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var pokeDetail = PokeDetail()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokeDetail.name
        setUpActivityIndicator()
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        pokeDetail.getPokeDetail {
            self.updateUserInterface()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func updateUserInterface() {
        heightLabel.text = "\(pokeDetail.height)"
        weightLabel.text = "\(pokeDetail.weight)"
        
        guard let url = URL(string: pokeDetail.imageURL) else { return }
        do {
            let data = try Data(contentsOf: url)
            pokemonImage.image = UIImage(data: data)
        } catch {
            print("ERROR: error thrown trying to get data from URL \(url)")
        }
    }
    
    func setUpActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
    }
}
