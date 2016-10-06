//
//  PokemonStat.swift
//  PokedexByCreativeIce
//
//  Created by Minni K Ang on 2016-10-03.
//  Copyright © 2016 Minni K Ang. All rights reserved.
//

import Foundation

class PokemonStat {
    
    var _statName: String!
    var _baseStat: Int!
    
    var statName: String {
        if _statName == nil {
            _statName = ""
        }
        return _statName
    }
    
    var baseStat: Int {
        if _baseStat == nil {
            _baseStat = 0
        }
        return _baseStat
    }
    
    init(statsDict: [String: Any]) {
        
        if let statDict = statsDict["stat"] as? [String: Any] {
            if let statName = statDict["name"] as? String {
                self._statName = statName
            }
        }
        
        if let baseStat = statsDict["base_stat"] as? Int {
            self._baseStat = baseStat
        }
    }
}
