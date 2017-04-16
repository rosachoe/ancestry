//
//  MemorialViewController.swift
//  Cemetery
//
//  Created by Rosa Choe on 4/11/17.
//  Copyright © 2017 Rosa Choe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MemorialViewController: UIViewController {
    var id: String?

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var pob: UILabel!
    @IBOutlet weak var dod: UILabel!
    @IBOutlet weak var pod: UILabel!
    
    var memorial: Memorial?
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://www.findagrave.com/cgi-bin/api.cgi?mode=memorialSummary&amp;memorialId=\(id ?? "")"
        
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["memorialSummary"].dictionaryObject {
                    self.memorial = Memorial.fromJSON(json: resData)
                    self.update()
                }
            }
        }
    }
    
    func update() {
        self.name?.text = "\(self.memorial?.firstName ?? "") \(self.memorial?.lastName ?? "")"
        self.dob?.text = "Date of Birth: \(self.memorial?.birthDate ?? "")"
        self.pob?.text = "Birthplace: \(self.memorial?.birthPlace ?? "")"

        self.dod?.text = "Date of Death: \(self.memorial?.deathDate ?? "")"
        self.pod?.text = "Place of Death: \(self.memorial?.deathPlace ?? "")"
        
        var photoURL = ""
        
        
        if (self.memorial?.hasPhoto)! {
            let url = "https://www.findagrave.com/cgi-bin/api.cgi?mode=memorialPhotos&amp;memorialId=\(self.memorial?.id ?? "")"
            Alamofire.request(url).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["memorialPhotos"].arrayObject {
                        photoURL = (resData as! [[String:AnyObject]])[0]["fileName"] as! String
                    }
                }
            }
            
            if let imgURL = URL(string: photoURL) {
                let imageData = try! UIKit.Data(contentsOf: imgURL)
                if imageData != nil{
                    self.photo.image = UIImage(data: imageData)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//- memorialSummary
//    - memorialId
//    - fullName
//    - Prefix
//    - Pregame
//    - firstName
//    - nickName
//    - middleName
//    - maidenName
//    - lastName
//    - suffix
//    - otherName
//    - firstOrig
//    - lastOrig
//    - Biography
//    - militaryRank
//    - militaryBranch
//    - birthDay
//    - birthMonth
//    - birthYear
//    - deathDay
//    - deathMonth
//    - deathYear
//    - birthCountryAbbrev
//    - birthCountryName
//    - birthStateId
//    - birthStateName
//    - birthCountyId
//    - birthCountyName
//    - deathStateId
//    - deathStateName
//    - deathCountyId
//    - deathCountyName
//    - deathCityName
//    - isFamous
//    - maPersonId
//    - paPersonId
//    - countryId
//    - publicNote
//    - stillLiving
//    - cemeteryId
//    - cemeteryName
//    - cemeteryCityName
//    - cemeteryCountyName
//    - cemeteryStateName
//    - cemeteryCountryName
//    - cemeteryHasPhoto
//    - formattedDate
//    - intermentHasPhoto
//    - personHasPhoto

}
