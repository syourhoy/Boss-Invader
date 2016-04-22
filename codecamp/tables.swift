//
//  tables.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 19/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Tables: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let defaults = NSUserDefaults.standardUserDefaults()
   
    
    @IBOutlet weak var tableView: UITableView!
 
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    

    var test = [String]()
    let cellIdentifier = "cell"
    var titles = ["Ma Sphere", "Mixte", "One to One"]
    var sectionTitles = ["Ma Sphere": [String](), "Mixte": [String](), "One to One": [String]()]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Profil/getUserSphere.php")!)
        let json: [String: AnyObject] = [
            "Email": defaults.stringForKey("Usermail")!
            ]
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
                    self.test = []
                    for table in json {
                        self.test.append(table["Theme"] as! String)
                    }
                    self.sectionTitles["Ma Sphere"] = self.test
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
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
        getMixteTables()
        get1to1Tables()
    }
    
    func getMixteTables() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Profil/getUserMixte.php")!)
        let json: [String: AnyObject] = [
            "Email": defaults.stringForKey("Usermail")!
        ]
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
                    self.test = []
                    for table in json {
                        self.test.append(table["Theme"] as! String)
                    }
                    self.sectionTitles["Mixte"] = self.test
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
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
    
    func get1to1Tables() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Profil/getUser1to1.php")!)
        let json: [String: AnyObject] = [
            "Email": defaults.stringForKey("Usermail")!
        ]
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
                    self.test = []
                    for table in json {
                        self.test.append(table["Titre"] as! String)
                    }
                    self.sectionTitles["One to One"] = self.test
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var str = titles[section]
        var str2 = sectionTitles[str]
        return str2!.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        var str = titles[indexPath.section]
        var var2 = sectionTitles[str]
        var var3 = var2![indexPath.row]
        cell.textLabel?.text = var3
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("bonjouuuuuuuur : ")
    }
}
