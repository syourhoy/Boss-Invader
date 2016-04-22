//
//  Home.swift
//  codecamp
//
//  Created by Loris TECHER on 18/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import Foundation

class Home: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var list: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    let locationMgr = CLLocationManager()
    var creatorName: String = ""
    var markerType: String = ""
    var markerOwner: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor(red: 42.0/255, green: 42.0/255, blue: 42.0/255, alpha: 1.0)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 110
            list.target = revealViewController()
            list.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rightViewRevealWidth = 150
            menu.target = revealViewController()
            menu.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
        mapView.delegate = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        showTables()
        showTablesMixte()
        showTables1to1()
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        print("Called didTap")
        let googleMarker = mapView.selectedMarker
        let markerValue: CLLocationCoordinate2D = googleMarker!.position
        self.markerType = googleMarker!.title!
        self.markerOwner = (googleMarker!.userData! as! NSArray)[1] as! String
        if (markerType == "Ma Sphere") {
            performSegueWithIdentifier("toSphere2", sender: self)
        }
        else if (markerType == "Mixte") {
            performSegueWithIdentifier("toMixte2", sender: self)
        }
        else if (markerType == "One to One") {
            performSegueWithIdentifier("toOne2", sender: self)
        }
        mapView.selectedMarker = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toMixte2") {
            let newProgramVar = self.markerOwner
            let destinationVC = segue.destinationViewController as! detailMixte
            destinationVC.m_email = newProgramVar
        } else if (segue.identifier == "toSphere2") {
            var newProgramVar = self.markerOwner
            let destinationVC = segue.destinationViewController as! detailSphere
            destinationVC.m_email = newProgramVar
        } else if (segue.identifier == "toOne2") {
            var newProgramVar = self.markerOwner
            let destinationVC = segue.destinationViewController as! detail1to1
            destinationVC.m_email = newProgramVar
        }
    }
    
    func showTables() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Main/getTablesSphere.php")!)
        let json: [String: AnyObject] = [:]
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                    for table in json {
                        let address = table["Adresse"] as! String
                        print(table["Email"] as! String)
                        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                            if placemarks?.count > 0 {
                                let placemark = placemarks?[0]
                                let location = placemark?.location
                                let coordinate = location?.coordinate
                                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                                let position = CLLocationCoordinate2DMake(coordinate!.latitude, coordinate!.longitude)
                                let london = GMSMarker(position: position)
                                london.title = "Ma Sphere"
                                london.snippet = "\nTheme: \(table["Theme"] as! String)\nParticipants: \(table["Inscrits"] as! String) / \(table["Participants"] as! String)"
                                london.userData = [table["Theme"] as! String, table["Email"] as! String]
                                london.icon = UIImage(named: "house")
                                london.map = self.mapView;
                            }
                        })
                    }
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            
        }
        task.resume()
    }
    
    func showTablesMixte() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Main/getTablesMixte.php")!)
        let json: [String: AnyObject] = [:]
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                    for table in json {
                        let address = table["Adresse"] as! String
                        print(table["Email"] as! String)
                        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                            if placemarks?.count > 0 {
                                let placemark = placemarks?[0]
                                let location = placemark?.location
                                let coordinate = location?.coordinate
                                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                                let position = CLLocationCoordinate2DMake(coordinate!.latitude, coordinate!.longitude)
                                let london = GMSMarker(position: position)
                                london.title = "Mixte"
                                london.snippet = "\nTheme: \(table["Theme"] as! String)\nParticipants: \(table["Inscrits"] as! String) / \(table["Participants"] as! String)"
                                london.userData = [table["Theme"] as! String, table["Email"] as! String]
                                london.icon = UIImage(named: "house")
                                london.map = self.mapView;
                            }
                        })
                    }
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            
        }
        task.resume()
    }
    func showTables1to1() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Main/getTables1to1.php")!)
        let json: [String: AnyObject] = [:]
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                    for table in json {
                        let address = table["Adresse"] as! String
                        print(table["Email"] as! String)
                        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                            if placemarks?.count > 0 {
                                let placemark = placemarks?[0]
                                let location = placemark?.location
                                let coordinate = location?.coordinate
                                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                                let position = CLLocationCoordinate2DMake(coordinate!.latitude, coordinate!.longitude)
                                let london = GMSMarker(position: position)
                                london.title = "One to One"
                                london.snippet = "\nTitre: \(table["Titre"] as! String)\nBudget: \(table["Budget"] as! String)"
                                london.userData = [table["Titre"] as! String, table["Email"] as! String]
                                london.icon = UIImage(named: "house")
                                london.map = self.mapView;
                            }
                        })
                    }
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            
        }
        task.resume()
    }
}

extension Home: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationMgr.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12.5, bearing: 0, viewingAngle: 0)
            locationMgr.stopUpdatingLocation()
        }
    }
}