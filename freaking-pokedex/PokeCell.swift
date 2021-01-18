//
//  PokeCell.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 29/02/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import UIKit

class PokeCell: UITableViewCell {
    
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var lblPokemon: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var imgPokeballMark: UIImageView!
    
    var pokemon: Pokemon!
    
    func setCell(aPokemon: Pokemon) {
        
        self.pokemon = aPokemon
        
        lblPokemon.text = self.pokemon.name.capitalizedString
        imagePokemon.image = UIImage(named: "\(self.pokemon.pokedexId)")
        lblPokedexId.text = "#" + String(format: "%03d", arguments: [self.pokemon.pokedexId])
        
        if self.pokemon.isCaptured {
            
            self.imgPokeballMark.hidden = false
        }
        else {
            self.imgPokeballMark.hidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}