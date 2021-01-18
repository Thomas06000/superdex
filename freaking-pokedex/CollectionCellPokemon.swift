//
//  CollectionCellPokemon.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 21/02/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import UIKit

class CollectionCellPokemon: UICollectionViewCell {
    
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var lblPokemon: UILabel!
    
    var pokemon: Pokemon!
    
    func setCell(aPokemon: Pokemon) {
        
        self.pokemon = aPokemon
        
        lblPokemon.text = self.pokemon.name.capitalizedString
        imagePokemon.image = UIImage(named: "\(self.pokemon.pokedexId)")        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5.0
    }
}