//
//  MoveCell.swift
//  freaking-pokedex
//
//  Created by Thomas AUGER on 02/03/16.
//  Copyright © 2016 Thomas AUGER. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {
    
    @IBOutlet weak var lblMoveName: UILabel!
    @IBOutlet weak var lblPower: UILabel!
    @IBOutlet weak var lblPP: UILabel!
    @IBOutlet weak var lblMoveDescription: UILabel!
    @IBOutlet weak var lblAccuracy: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    
    func setCell(moveName: String, level: String, power: String, pp: String, moveDescription: String, accuracy: String) {
        
        lblMoveName.text = moveName
        lblLevel.text = level
        lblPower.text = power
        lblPP.text = pp
        lblMoveDescription.text = moveDescription
        lblAccuracy.text = accuracy
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
