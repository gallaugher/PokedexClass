//
//  PokeDetail.swift
//  PokedexClass
//
//  Created by John Gallaugher on 11/12/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PokeDetail {
    var name = ""
    var weight = 0.0
    var height = 0.0
    var imageURL = ""
    var pokeURL = ""
    
    func getPokeDetail(completed: @escaping () -> () ) {
        Alamofire.request(pokeURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.weight = json["weight"].doubleValue
                self.height = json["height"].doubleValue
                self.imageURL = json["sprites"]["front_default"].stringValue
                print("Here's the data for pokemon \(self.name), \(self.weight),\(self.height) and \(self.pokeURL) ")
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url\(self.pokeURL)")
            }
            completed()
        }
    }
}
