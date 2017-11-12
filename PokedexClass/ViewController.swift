//
//  ViewController.swift
//  PokedexClass
//
//  Created by John Gallaugher on 11/7/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var pokemon = Pokemon()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpActivityIndicator()
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        pokemon.getPokemon {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.navigationItem.title = "Loaded \(self.pokemon.pokeArray.count) of Pokemon: \(self.pokemon.totalPokemon)"
        }
    }
    
    func setUpActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            destination.pokeDetail.name = pokemon.pokeArray[selectedRow].name
            destination.pokeDetail.pokeURL = pokemon.pokeArray[selectedRow].url
        }
    }
    
    func loadNext() {
        if pokemon.pokemonURL.contains("http")
        {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            pokemon.getPokemon{
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationItem.title = "Retrieved \(self.pokemon.pokeArray.count) of \(self.pokemon.totalPokemon)"
                self.loadNext()
            }
        }
    }
    
    @IBAction func getAlPressed(_ sender: UIBarButtonItem) {
        loadNext()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.pokeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row+1). "+pokemon.pokeArray[indexPath.row].name
        if indexPath.row == pokemon.pokeArray.count-1 && !pokemon.urlsRetrieved.contains(pokemon.pokemonURL) {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            pokemon.getPokemon {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationItem.title = "Loaded \(self.pokemon.pokeArray.count) of Pokemon: \(self.pokemon.totalPokemon)"
            }
        }
        return cell
    }
}

