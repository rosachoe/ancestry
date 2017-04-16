//
//  CemeteryViewController.swift
//  Cemetery
//
//  Created by Rosa Choe on 4/11/17.
//  Copyright © 2017 Rosa Choe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CemeteryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var name: UINavigationItem!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var memorialTable: UITableView!
    
    var cemetery: Cemetery?
    var memorials = [[String:AnyObject]]()
    var mems = [Memorial]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://www.findagrave.com/cgi-bin/api.cgi?mode=name&amp;cemeteryId=\(cemetery?.id ?? "")&amp;limit=\(cemetery?.memCount ?? 25)&amp;skip=0&amp;includeThumb=1"
        
         Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["memorial"].arrayObject {
                    self.memorials = resData as! [[String: AnyObject]]
                }
                if self.memorials.count > 0 {
                    self.memorialTable.reloadData()
                }
            }
        }
        
        memorialTable.delegate = self
        memorialTable.dataSource = self
        
        self.name.title = cemetery?.title
        self.street.text = cemetery?.street
        self.city.text = "\(cemetery?.city ?? ""), \(cemetery?.state ?? "")"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memorial", for: indexPath) as! MemorialTableViewCell
        
        var dict = memorials[(indexPath as NSIndexPath).row]
        cell.name?.text = "\(dict["firstName"] as? String ?? "") \(dict["lastName"] as? String ?? "")"
        cell.dob?.text = "DOB: \(dict["birthMonth"] as? String ?? "")/\(dict["birthDay"] as? String ?? "")/\(dict["birthYear"] as? String ?? "")"
        cell.id = dict["memorialId"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memorials.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = memorialTable.cellForRow(at: indexPath) as! MemorialTableViewCell
        performSegue(withIdentifier: "cemToMemorial", sender: cell)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MemorialViewController {
            dest.id = (sender as! MemorialTableViewCell).id
        }
    }
 

}
