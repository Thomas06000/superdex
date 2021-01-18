//
//  Pokemon.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 21/02/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _weight: String!
    private var _height: String!
    private var _description: String!
    private var _types: String!
    private var _baseAttack: String!
    private var _defense: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvoltuionLvl: String!
    private var _healthPoint: String!
    private var _spAttack: String!
    private var _spDef: String!
    private var _speed: String!
    
    // @TODO: Check nullity putain de bordel de merde, sinon ca crash...
    // Getters --------------
    var name: String {
        return _name.lowercaseString
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var weight: String {
        return _weight
    }
    var height: String {
        return _height
    }
    var description: String {
        return _description
    }
    var types: String {
        return _types
    }
    var baseAttack: String {
        return _baseAttack
    }
    var defense: String {
        return _defense
    }
    var nextEvolutionName: String {
        return _nextEvolutionName
    }
    var nextEvolutionId: String {
        return _nextEvolutionId
    }
    var nextEvolutionLvl: String {
        return _nextEvoltuionLvl
    }
    var healthPoint: String {
        return _healthPoint
    }
    var spAttack: String {
        return _spAttack
    }
    var spDef: String {
        return _spDef
    }
    var speed: String {
        return _speed
    }
    var isCaptured: Bool {
        if let b: Bool = NSUserDefaults.standardUserDefaults().boolForKey(String(self.pokedexId)){
            return b
        }
        return false
    }
    // -----------------------
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
    }
    
    func downloadPokemonDetails(completed: DownloadCompleted) {
        
        let pokeUrl = NSURL(string: API_POKEMON_URL + "/" + String(self._pokedexId) + "/")!
        
        Alamofire.request(.GET, pokeUrl).validate().responseJSON { response in
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    if let weight = json["weight"].stringValue as String? {
                        
                        let nb = Double(weight)!
                        let str = String(nb / 10)
                        let finalStr = str + "kg   "
                        
                        self._weight = finalStr
                    }
                    
                    if let height = json["height"].stringValue as String? {
                        
                        let nb = Double(height)!
                        let str = String(nb / 10)
                        let finalStr = str + "m "
                        
                        self._height = finalStr
                    }
                    
                    if let defense = json["defense"].stringValue as String? {
                        
                        self._defense = defense
                    }
                    
                    if let attack = json["attack"].stringValue as String? {
                        
                        self._baseAttack = attack
                    }
                    
                    if let types = json["types"].array {
                        
                        var pokeTypes: String = ""
                        
                        for type in types {
                            
                            pokeTypes += type["name"].stringValue
                            pokeTypes += " "
                            
                        }
                        self._types = pokeTypes.capitalizedString
                    }
                    
                    if let nextEvolutionName = json["evolutions"][0]["to"].stringValue as String? {
                        
                        // FIXME: No support for mega evolution
                        if !nextEvolutionName.containsString("mega") {
                            self._nextEvolutionName = nextEvolutionName
                        }
                        else {
                            self._nextEvolutionName = ""
                        }
                    }
                    
                    if let nextEvolutionId = json["evolutions"][0]["resource_uri"].stringValue as String? {
                        
                        let str = nextEvolutionId.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                        
                        let newStr = str.stringByReplacingOccurrencesOfString("/", withString: "")
                        
                        self._nextEvolutionId = newStr
                    }
                    
                    if let nextEvolutionLvl = json["evolutions"][0]["level"].stringValue as String? {
                        
                        self._nextEvoltuionLvl = "Lvl " + nextEvolutionLvl
                        
                        if nextEvolutionLvl == "" {
                            
                            if let evolutionMethod = json["evolutions"][0]["method"].stringValue as String? {
                                
                                self._nextEvoltuionLvl = evolutionMethod.capitalizedString
                            }
                        }
                    }
                    
                    if let healthPoint = json["hp"].stringValue as String? {
                        
                        self._healthPoint = healthPoint
                    }
                    
                    if let spAttack = json["sp_atk"].stringValue as String? {
                        
                        self._spAttack = spAttack
                    }
                    
                    if let spDef = json["sp_def"].stringValue as String? {
                        
                        self._spDef = spDef
                    }
                    
                    if let speed = json["speed"].stringValue as String? {
                        
                        self._speed = speed
                    }
                }
                
            case .Failure(let error):
                print(error)
            }
            completed()
        }
    }
    
    func downloadPokemonDescription(completed: DownloadCompleted) {
        
        let pokeUrl = NSURL(string: API_POKEMON_URL + "/" + String(self._pokedexId) + "/")!
        
        Alamofire.request(.GET, pokeUrl).validate().responseJSON { response in
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    if let urlDescription = json["descriptions"][0]["resource_uri"].stringValue as String? {
                        let urlToDescription = POKEAPI_BASE_URL + urlDescription
                        
                        Alamofire.request(.GET, urlToDescription).validate().responseJSON { response in
                            
                            switch response.result {
                            case .Success:
                                if let value = response.result.value {
                                    
                                    let json = JSON(value)
                                    
                                    if let description = json["description"].stringValue as String? {
                                        
                                        let str = description.stringByReplacingOccurrencesOfString("POKMON", withString: "Pokémon").stringByReplacingOccurrencesOfString("POKMONs", withString: "Pokémon").stringByReplacingOccurrencesOfString("Pokmons", withString: "Pokémon")
                                        
                                        self._description = str
                                    }
                                }
                                
                            case .Failure(let error):
                                print(error)
                            }
                            completed()
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}