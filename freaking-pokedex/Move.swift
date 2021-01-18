//
//  Move.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 03/03/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Move {
    
    private var _movesName = [String]()
    private var _movesDescription = [String]()
    private var _pps = [String]()
    private var _powers = [String]()
    private var _accuracys = [String]()
    private var _levels = [String]()
    
    // this is for binding a list of move to a pokemon
    private var _pokedexId: Int!
    
    // Getters
    var movesName: [String] {
        return self._movesName
    }
    var movesDescription: [String] {
        return self._movesDescription
    }
    var pps: [String] {
        return self._pps
    }
    var powers: [String] {
        return self._powers
    }
    var accuracys: [String] {
        return self._accuracys
    }
    var levels: [String] {
        return self._levels
    }
    //---------------
    
    
    init(pokedexId: Int) {
        self._pokedexId = pokedexId
    }
    
    func downloadPokemonMoves(completed: DownloadCompleted) {
        
        let pokemonUrl = NSURL(string: API_POKEMON_URL + "/" + String(self._pokedexId) + "/")!
        
        Alamofire.request(.GET, pokemonUrl).validate().responseJSON { response in
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    // Here we go ! - Auger TAMA 
                    if let urlMoveDescription = json["moves"].array {
                        
                        for url in urlMoveDescription {
                            
                            // Filter moves by level up
                            if url["learn_type"].stringValue as String? != "level up" {
                                
                                continue
                            }
                            
                            if let level = url["level"].stringValue as String? {
                                
                                self._levels.append(String(level))
                            }
                            
                            let urlToDescription = POKEAPI_BASE_URL + url["resource_uri"].stringValue
                            
                            Alamofire.request(.GET, urlToDescription).validate().responseJSON { response in
                                
                                switch response.result {
                                    
                                case .Success:
                                    
                                    if let value = response.result.value {
                                        
                                        let json = JSON(value)
                                        
                                        // Start of move parsing, putain je suis trop fort bordel, i'm speaking two langage actually...
                                        // So fabulous, so cool, so magnificient
                                        if let name = json["name"].stringValue as String? {
                                            
                                            self._movesName.append(name)
                                        }
                                        
                                        if let description = json["description"].stringValue as String? {
                                            
                                            self._movesDescription.append(description)
                                        }
                                        
                                        if let accuracy = json["accuracy"].stringValue as String? {
                                            
                                            self._accuracys.append(accuracy)
                                        }
                                        
                                        if let power = json["power"].stringValue as String? {
                                            
                                            self._powers.append(power)
                                        }
                                        
                                        if let pp = json["pp"].stringValue as String? {
                                            
                                            self._pps.append(pp)
                                        }
                                    }
                                    completed()
                                    
                                case .Failure(let error):
                                    print(error)
                                }
                            }
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
}