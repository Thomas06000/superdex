//
//  DashboardVC.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 12/03/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    var pokemons: [Pokemon]!
    
    @IBOutlet weak var lblPokemonCaptured: UILabel!
    @IBOutlet weak var lblPokemonStat: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokeStat()
    }
    
    func pokeStat() {
        
        var pokemonsCaptured: [Pokemon] = []
        for poke in pokemons {
            
            if poke.isCaptured {
                pokemonsCaptured.append(poke)
            }
        }
        
        lblPokemonStat.text = String(pokemonsCaptured.count) + " / " + String(pokemons.count)
        
        let pokeStats: Int = pokemonsCaptured.count * 100 / pokemons.count
        if pokemonsCaptured.count > 0 {
            
            lblPokemonCaptured.text = String(pokeStats) + "%"
        }
        else {
            lblPokemonCaptured.text = "0%"
        }
    }
    
    @IBAction func btnClose(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
