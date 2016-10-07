//
//  Pokemon.swift
//  PokedexByCreativeIce
//
//  Created by Minni K Ang on 2016-04-01.
//  Copyright © 2016 Minni K Ang. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvolutionTxt: String!
    fileprivate var _nextEvolutionId: String!
    fileprivate var _nextEvolutionLvl: String!
    
    var name: String {
        get {
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }

    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }

    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }

    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }

    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }

    var nextEvolutionTxt: String {
        get {
            if _nextEvolutionTxt == nil {
                _nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
    }

    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }

    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var pokemonStat: PokemonStat!
    var pokemonStats = [PokemonStat]()
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        let url = URL(string: URL_BASE.appending("\(pokedexId)/"))!
        Alamofire.request(url).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? [String: Any] {
                
                if let weight = dict["weight"] as? Int {
                self._weight = String(weight)
                }
                
                if let height = dict["height"] as? Int {
                    self._height = String(height)
                }
                
                if let stats = dict["stats"] as? [[String: Any]] {
                    
                    for stat in stats {
                        let pokemonStat = PokemonStat(statsDict: stat)
                        self.pokemonStats.append(pokemonStat)
                    }
                }

                if let types = dict["types"] as? [[String: Any]] {
                    for object in types {
                        if let type = object["type"] as? [String: Any] {
                            if let pokemonType = type["name"] as? String {
                                print(pokemonType)      // SHOWS DATA CORRECTLY PARSED
                            }
                        }
                    }
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let nsurl = URL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(nsurl).responseJSON { response in
                            
                            let descResult = response.result
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                        }
                    
                    } else {
                    
                    self._description = ""
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                        
                        if let to = evolutions[0]["to"] as? String {
                            
                            if to.range(of: "mega") == nil {
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    
                                    let num = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvolutionId = num
                                    self._nextEvolutionTxt = to
                                    
                                    if let lvl = evolutions[0]["level"] as? Int {
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                }
                            }
                        }
                    }

                }
            }
            completed()
        }
    }
}
