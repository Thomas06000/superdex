//
//  mainVC.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 29/02/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import UIKit
import SwiftCSV
import AVFoundation
import GoogleMobileAds

class mainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var pokeTableView: UITableView!
    @IBOutlet weak var mainSearchBar: UISearchBar!
    @IBOutlet weak var bannerViewAd: GADBannerView!
    
    var openingSound: AVAudioPlayer!
    var pokemons = [Pokemon]()
    var pokemonsFiltered = [Pokemon]()
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ads
        bannerViewAd.adUnitID = "{secret}"
        bannerViewAd.rootViewController = self
        bannerViewAd.loadRequest(GADRequest())
        
        mainSearchBar.delegate = self
        
        parsePokemonCSV()
        
        pokeTableView.reloadData()
    }
    
    // Prevent auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.pokeTableView.endEditing(true)
    }
    
    @IBAction func btnDashboard(sender: AnyObject) {
        
        performSegueWithIdentifier("dashboardVC", sender: pokemons)
    }
    
    override func viewDidAppear(animated: Bool) {
        pokeTableView.reloadData()
    }
    
    func parsePokemonCSV() {
        
        do {
            
            let pathToCSV = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
            let csv = try CSV(name: pathToCSV)
            let rows = csv.rows
            
            for row in rows {
                
                let id = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokemon(name: name, pokedexId: id)
                pokemons.append(pokemon)
            }
        }
        catch {
            print("Duuuuuude, something went wrong with the dang CSV parser...")
        }
    }
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBAction func btnPlay(sender: AnyObject) {
        
        if !openingSound.playing {
            
            openingSound.play()
            sender.layer.opacity = 1
        }
        else {
            
            // TODO: Fix stop method, must restart sound
            openingSound.currentTime = 0
            openingSound.stop()
            sender.layer.opacity = 0.5
        }
    }
    
    // Search bar required stuff
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" || searchBar.text == nil {
            
            isSearching = false
            view.endEditing(true)
            
            pokeTableView.reloadData()
        }
        else {
            
            isSearching = true
            let searchString = searchBar.text!.lowercaseString
            
            // make an array of filtered pokemon
            pokemonsFiltered = pokemons.filter({$0.name.rangeOfString(searchString) != nil})
            pokeTableView.reloadData()
        }
    }
    
    // close keyboard when search button is pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // Collection view required stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return pokemonsFiltered.count
        }
        
        return pokemons.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = pokeTableView.dequeueReusableCellWithIdentifier("PokeCell") as? PokeCell {
            
            let pokemon: Pokemon!
            
            if isSearching {
                pokemon = pokemonsFiltered[indexPath.row]
            }
            else {
                pokemon = pokemons[indexPath.row]
            }
            
            cell.setCell(pokemon)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pokemon: Pokemon!
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if isSearching {
            
            pokemon = pokemonsFiltered[indexPath.row]
        }
        else {
            
            pokemon = pokemons[indexPath.row]
        }
        
        performSegueWithIdentifier("pokemonDetailVC", sender: pokemon)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pokemonDetailVC" {
            
            if let detailVC = segue.destinationViewController as? PokemonDetailVC {
                
                if let aPokemon = sender as? Pokemon {
                    
                    detailVC.pokemon = aPokemon
                    
                    // Bind move list to a pokemon
                    if let aMoveList = Move(pokedexId: aPokemon.pokedexId) as Move? {
                        
                        detailVC.moveList = aMoveList
                    }
                }
            }
        }
        
        if segue.identifier == "dashboardVC" {
            
            if let dashboardVC = segue.destinationViewController as? DashboardVC {
                
                if let pokes = sender as? [Pokemon] {
                    
                    dashboardVC.pokemons = pokes
                }
            }
        }
    }
}








