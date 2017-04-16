//
//  Memorial.swift
//  Cemetery
//
//  Created by Rosa Choe on 4/11/17.
//  Copyright © 2017 Rosa Choe. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Memorial {
    let id: String?
    let firstName: String?
    let lastName: String?
    let birthDate: String?
    let deathDate: String?
    let birthPlace: String?
    let deathPlace: String?
    let hasPhoto: Bool?
    
    init(id: String, firstName: String, lastName: String, birthDate: String, deathDate: String, birthPlace: String, deathPlace: String, hasPhoto: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.birthPlace = birthPlace
        self.deathPlace = deathPlace
        self.hasPhoto = hasPhoto
        
    }
    
    class func fromJSON(json: [String:Any]) -> Memorial{
        var id = ""
        var firstName = ""
        var lastName = ""
        var birthDate = ""
        var deathDate = ""
        var birthPlace = ""
        var deathPlace = ""
        var hasPhoto = false
        
        if let jsonid = json["memorialId"] as? String{
            id = jsonid
        }
        
        if let jsonfirstName = json["firstName"] as? String {
            firstName = jsonfirstName
        }
        
        if let jsonlastName = json["lastName"] as? String{
            lastName = jsonlastName
        }
        
        if let jsonbirthDay = json["birthDay"] as? String, let jsonbirthMonth = json["birthMonth"], let jsonbirthYear = json["birthYear"] {
            birthDate = "\(jsonbirthMonth)/\(jsonbirthDay)/\(jsonbirthYear)"
        }
        
        if let jsondeathDay = json["deathDay"] as? String, let jsondeathMonth = json["deathMonth"], let jsondeathYear = json["deathYear"] {
            deathDate = "\(jsondeathMonth)/\(jsondeathDay)/\(jsondeathYear)"
        }
        
        if let jsonbirthCity = json["birthCityName"] as? String, let jsonbirthState = json["birthStateName"] as? String{
            birthPlace = "\(jsonbirthCity), \(jsonbirthState)"
        }
        
        if let jsondeathCity = json["deathCityName"] as? String, let jsondeathState = json["deathStateName"] as? String{
            deathPlace = "\(jsondeathCity), \(jsondeathState)"
        }
        
        if let jsonPhoto = json["intermentHasPhoto"] as? String {
            switch jsonPhoto {
            case "Y":
                hasPhoto = true
            default:
                hasPhoto = false
            }
        }
        
        
        
        
        return Memorial(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate, deathDate: deathDate, birthPlace: birthPlace, deathPlace: deathPlace, hasPhoto: hasPhoto)
    }
}

