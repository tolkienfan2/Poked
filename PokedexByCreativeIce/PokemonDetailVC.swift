//
//  PokemonDetailVC.swift
//  PokedexByCreativeIce
//
//  Created by Minni K Ang on 2016-04-01.
//  Copyright © 2016 Minni K Ang. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }


}
