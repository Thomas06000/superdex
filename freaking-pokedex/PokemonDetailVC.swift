//
//  PokemonDetailVC.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 24/02/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TABLE VIEW HIDE/SHOW !!!
    @IBOutlet weak var movesView: UIView!
    
    @IBOutlet weak var movesTableView: UITableView!
    // ----------------------------------------------
    
    @IBOutlet weak var lblPokemonName: UILabel!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPokeId: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblBaseAttack: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var imgNextEvolution: UIImageView!
    @IBOutlet weak var lblSpDefense: UILabel!
    @IBOutlet weak var lblSpAttack: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblHealthPoint: UILabel!
    @IBOutlet weak var lblNextEvolutionLvl: UILabel!
    @IBOutlet weak var lblNextEvolutionName: UILabel!
    
    @IBOutlet weak var lblNoEvolutionMessage: UILabel!
    @IBOutlet weak var lblEvolutionTitle: UILabel!
    @IBOutlet weak var btnWannaCatchThemAll: UIButton!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    var pokemon: Pokemon!
    var moveList: Move!
    var pokemonCries: AVAudioPlayer!
    var pokemonCaptured: AVAudioPlayer!
    var pokemonDeCaptured: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movesTableView.dataSource = self
        movesTableView.delegate = self
        
        clearLabels()
        loadLocalPokemonData()
        initializePokeCriesSound()
        captureSoundInit()
        
        // Check internet connection
        if Reachability.isConnectedToNetwork() {
            
            hydratePokemonDetails()
            loadMoveList()
        }
        else {
            
            let alert = UIAlertView(title: "No Internet Connection :(", message: "Make sure your Superdex is connected to the internet.", delegate: nil, cancelButtonTitle: "Ok...")
            alert.show()
        }
    }
    
    // Prevent auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func btnWannaCatchThemAll(sender: AnyObject) {
        
        if let isCaptured: Bool = (NSUserDefaults.standardUserDefaults().boolForKey(String(self.pokemon.pokedexId))) {
            
            if isCaptured {
                pokemonDeCaptured.play()
                NSUserDefaults.standardUserDefaults().removeObjectForKey(String(self.pokemon.pokedexId))
                btnWannaCatchThemAll.alpha = 0.5
            }
            else {
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.fromValue = 0.0
                rotationAnimation.toValue = 2 * M_PI
                rotationAnimation.duration = 0.8
                btnWannaCatchThemAll.alpha = 1
                
                self.btnWannaCatchThemAll.layer.addAnimation(rotationAnimation, forKey: nil)
                
                pokemonCaptured.play()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: String(self.pokemon.pokedexId))
            }
        }
        else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: String(self.pokemon.pokedexId))
            pokemonCaptured.play()
        }
    }
    
    func captureSoundInit() {
        
        let sound = NSBundle.mainBundle().pathForResource("pokemon caught", ofType: "mp3")!
        let soundUrl = NSURL(fileURLWithPath: sound)
        
        let soundDemark = NSBundle.mainBundle().pathForResource("pokemon out", ofType: "wav")!
        let soundDemarkUrl = NSURL(fileURLWithPath: soundDemark)
        
        do {
            try pokemonCaptured = AVAudioPlayer(contentsOfURL: soundUrl)
            try pokemonDeCaptured = AVAudioPlayer(contentsOfURL: soundDemarkUrl)
        }
        catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    func loadMoveList() {
        
        moveList.downloadPokemonMoves { () -> () in
            
            self.movesTableView.reloadData()
        }
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Hide/Show sub views...
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControl(sender: AnyObject) {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            
            movesView.hidden = false
            imgPokemon.hidden = true
        }
        else {
            movesView.hidden = true
            imgPokemon.hidden = false
        }
    }
    
    @IBAction func btnPlayCries(sender: AnyObject) {
        
        if pokemonCries != nil {
            
            pokemonCries.play()
        }
        else {
            self.title = "No sound for this Pokemon"
        }
    }
    
    func hydratePokemonDetails() {
        
        pokemon.downloadPokemonDetails { () -> () in
            
            self.lblWeight.text = self.pokemon.weight
            self.lblHeight.text = self.pokemon.height
            self.lblType.text = self.pokemon.types
            self.lblBaseAttack.text = self.pokemon.baseAttack
            self.lblDefense.text = self.pokemon.defense
            
            // Check if evolution exist...
            if self.pokemon.nextEvolutionName != "" {
                
                self.imgNextEvolution.image = UIImage.gifWithName("\(self.pokemon.nextEvolutionId)")
                self.lblNextEvolutionName.text = self.pokemon.nextEvolutionName
                self.lblNextEvolutionLvl.text = self.pokemon.nextEvolutionLvl
            }
            else {
                
                self.lblNoEvolutionMessage.hidden = false
                self.lblNextEvolutionName.text = ""
                self.lblNextEvolutionLvl.text = ""
                self.lblEvolutionTitle.text = ""
            }
            
            self.lblHealthPoint.text = self.pokemon.healthPoint
            self.lblSpAttack.text = self.pokemon.spAttack
            self.lblSpDefense.text = self.pokemon.spDef
            self.lblSpeed.text = self.pokemon.speed
            
            let healthPoint = Int(self.lblHealthPoint.text!)!
            let attack = Int(self.lblBaseAttack.text!)!
            let defense = Int(self.lblDefense.text!)!
            let spAttack = Int(self.lblSpDefense.text!)!
            let spDefense = Int(self.lblSpDefense.text!)!
            let speed = Int(self.lblSpeed.text!)!
            
            let total = healthPoint + attack + defense + spAttack + spDefense + speed
            
            self.lblTotal.text = String(total)
        }
        
        pokemon.downloadPokemonDescription { () -> () in
            
            self.lblDescription.text = self.pokemon.description
        }  
    }
    
    func loadLocalPokemonData() {
        
        lblPokemonName.text = pokemon.name.capitalizedString
        lblPokeId.text  = "#" + String(pokemon.pokedexId)
        imgPokemon.image = UIImage.gifWithName("\(pokemon.pokedexId)")
        
        if pokemon.isCaptured {
            btnWannaCatchThemAll.alpha = 1
        }
        else {
            btnWannaCatchThemAll.alpha = 0.5
        }
        
    }
    
    func initializePokeCriesSound() {
        
        // FIXME: Because there is 651 sounds for 718 Pokemons
        if pokemon.pokedexId <= 651 {
            
            let pathPokeCries = NSBundle.mainBundle().pathForResource("\(pokemon.pokedexId)", ofType: "wav")!
            let pokeCriesUrl = NSURL(fileURLWithPath: pathPokeCries)
            
            do {
                try pokemonCries = AVAudioPlayer(contentsOfURL: pokeCriesUrl)
            }
            catch let err as NSError {
                
                print(err.debugDescription)
            }
        }
        else {
            pokemonCries = nil
        }
    }
    
    func clearLabels() {
        
        lblHeight.text = "--"
        lblWeight.text = "--"
        lblType.text = ""
        lblDescription.text = "--"
        lblBaseAttack.text = "--"
        lblDefense.text = "--"
        lblSpDefense.text = "--"
        lblSpAttack.text = "--"
        lblSpeed.text = "--"
        lblNextEvolutionLvl.text = "--"
        lblNextEvolutionName.text = "--"
        imgNextEvolution.image = nil
        imgPokemon.image = nil
        lblHealthPoint.text = "--"
    }
    
    // Tableview stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.moveList.movesName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = movesTableView.dequeueReusableCellWithIdentifier("MoveCell") as? MoveCell {
            
            cell.setCell(moveList.movesName[indexPath.row], level: moveList.levels[indexPath.row], power: moveList.powers[indexPath.row], pp: moveList.pps[indexPath.row], moveDescription: moveList.movesDescription[indexPath.row], accuracy: moveList.accuracys[indexPath.row])
            
            
            if indexPath.row % 2 == 0 {
                
                cell.backgroundColor = UIColor.blackColor()
            }
            else {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
}


