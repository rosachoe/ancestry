//
//  MapViewController.swift
//  Cemetery
//
//  Created by Rosa Choe on 4/11/17.
//  Copyright © 2017 Rosa Choe. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var map: MKMapView!
    let regionRadius: CLLocationDistance = 10000
//    let annotations = [MKPointAnnotation]()
    var cemeteries = [[String:AnyObject]]()
    var cems = [Cemetery]()
    
//    let cemetery = Cemetery(title: "Berkeley Cemetery", coordinate: CLLocationCoordinate2D(latitude: 44.3040000, longitude: -73.1094000))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        let initialLoc = CLLocation(latitude: 37.8716, longitude: -122.2727)
        centerMapOnLocation(location: initialLoc)
        
        Alamofire.request("https://www.findagrave.com/cgi-bin/api.cgi?mode=cemetery&amp;cemeteryLatitude=37.8716&cemeteryLongitude=-122.2727&rangeInMiles=50&amp;limit=405&amp;skip=0").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["cemetery"].arrayObject {
                    self.cemeteries = resData as! [[String:AnyObject]]
                    self.initData()
                }
//                if self.cemeteries.count > 0 {
//                    self.map.reloadInputViews()
//                }
                
            }
        }

    }
    
    func initData() {
        var tempCems = [Cemetery]()
        for i in 0...self.cemeteries.count-1 {
            if let cem = Cemetery.fromJSON(json: cemeteries[i]) {
                tempCems.append(cem)
                map.addAnnotation(cem)
            }
        }
        self.cems = tempCems
    }
    

    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion =
            MKCoordinateRegionMakeWithDistance(
                location.coordinate,
                regionRadius * 2.0,
                regionRadius * 2.0)
        map.setRegion(coordinateRegion,
                          animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        performSegue(withIdentifier: "mapToCemetery", sender: view)
//    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mapToCemetery", sender: view.annotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CemeteryViewController {
            destination.cemetery = sender as? Cemetery
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Cemetery {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = map.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }

}
