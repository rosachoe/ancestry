//
//  Cemetery.swift
//  Cemetery
//
//  Created by Rosa Choe on 4/11/17.
//  Copyright © 2017 Rosa Choe. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

class Cemetery: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let id: String?
    let street: String?
    let city: String?
    let state: String?
    let hasPhoto: Bool
    let memCount: Int
    
    init(id: String, title: String, coordinate: CLLocationCoordinate2D, street: String, city: String, state: String, hasPhoto: Bool, memCount: Int) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.street = street
        self.city = city
        self.state = state
        self.hasPhoto = hasPhoto
        self.memCount = memCount
        super.init()
    }
    
    class func fromJSON(json: [String:AnyObject]) -> Cemetery? {
        var id = ""
        var title = ""
        var street = ""
        var city = ""
        var state = ""
        var hasPhoto = false
        var memCount = 0
        
        if let jsonid = json["cemeteryId"] as? String {
            id = jsonid
        }
        
        if let jsonTitle = json["cemeteryName"] as? String {
            title = jsonTitle
        }
        
        if let jsonstreet = json["streetAddress"] as? String {
            street = jsonstreet
        }
        
        if let jsoncity = json["cityName"] as? String {
            city = jsoncity
        }
        
        if let jsonstate = json["stateName"] as? String {
            state = jsonstate
        }
        
        if let jsonphoto = json["hasPhoto"] as? String {
            switch jsonphoto {
            case "Y":
                hasPhoto = true
            default:
                hasPhoto = false
            }
        }
        
        if let jsonMems = Int((json["approxInterments"] as? String)!) {
            memCount = jsonMems
        }
        
        var coordinate: CLLocationCoordinate2D
        if let lat = Double((json["latitude"] as? String)!), let lon = Double((json["longitude"] as? String)!) {
            coordinate = CLLocationCoordinate2DMake(lat, lon)
            return Cemetery(id: id, title: title, coordinate: coordinate, street: street, city: city, state: state, hasPhoto: hasPhoto, memCount: memCount)
        }
        return nil
        
        
        
    }
    
    
}
