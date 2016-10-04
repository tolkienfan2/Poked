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
    fileprivate var _pokemonUrl: String!
    
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
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(_ completed: @escaping DownloadComplete) {
        
        let url = URL (string: _pokemonUrl)!
        Alamofire.request(url).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
 
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }

                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                }

                if let types = dict["types"] as? [Dictionary<String,String>] , types.count > 0 {
                    
                    if let type = types[0]["name"] {
                        
                        self._type = type
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1 ..< types.count {
                            if let type = types[x]["name"] {
                                self._type! += "/\(type)"
                            }
                        }
                        
                    } else {
                        
                        //self._type = ""
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
                            
                            completed()
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
        }
    }
}
