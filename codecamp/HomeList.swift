//
//  HomeList.swift
//  codecamp
//
//  Created by Loris TECHER on 18/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import Foundation

class HomeList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var list: UIBarButtonItem!
    @IBOutlet weak var menu: UIBarButtonItem!
    var tmp = String()
    var test = [String]()
    var test2 = [String]()
    let cellIdentifier = "cell"
    var titles = ["Ma Sphere", "Mixte", "One to One"]
    var sectionTitles = ["Ma Sphere": [String](), "Mixte": [String](), "One to One": [String]()]
    var sectionEmails = ["Ma Sphere": [String](), "Mixte": [String](), "One to One": [String]()]
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
                    self.test = []
                    self.test2 = []
                    for table in json {
                        self.test.append(table["Theme"] as! String)
                        self.test2.append(table["Email"] as! String)
                    }
                    self.sectionTitles["Ma Sphere"] = self.test
                    self.sectionEmails["Ma Sphere"] = self.test2
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
                    self.test = []
                    self.test2 = []
                    for table in json {
                        self.test.append(table["Theme"] as! String)
                        self.test2.append(table["Email"] as! String)
                    }
                    self.sectionTitles["Mixte"] = self.test
                    self.sectionEmails["Mixte"] = self.test2
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
                    self.test = []
                    self.test2 = []
                    for table in json {
                        self.test.append(table["Titre"] as! String)
                        self.test2.append(table["Email"] as! String)
                    }
                    self.sectionTitles["One to One"] = self.test
                    self.sectionEmails["One to One"] = self.test2
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
        let str = titles[section]
        let str2 = sectionTitles[str]
        return str2!.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let str = titles[indexPath.section]
        var var2 = sectionTitles[str]
        let var3 = var2![indexPath.row]
        cell.textLabel?.text = var3
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(titles[indexPath.section] == "Ma Sphere") {
            let title = titles[indexPath.section]
            tmp = sectionEmails[title]![indexPath.row]
            performSegueWithIdentifier("toSphere", sender: self)
        } else if (titles[indexPath.section] == "Mixte") {
            let title = titles[indexPath.section]
            tmp = sectionEmails[title]![indexPath.row]
            performSegueWithIdentifier("toMixte", sender: self)
        } else if (titles[indexPath.section] == "One to One") {
            let title = titles[indexPath.section]
            tmp = sectionEmails[title]![indexPath.row]
            performSegueWithIdentifier("toOne", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toMixte") {
            let newProgramVar = self.tmp
            let destinationVC = segue.destinationViewController as! detailMixte
            destinationVC.m_email = newProgramVar
        } else if (segue.identifier == "toSphere") {
            var newProgramVar = self.tmp
            let destinationVC = segue.destinationViewController as! detailSphere
            destinationVC.m_email = newProgramVar
        } else if (segue.identifier == "toOne") {
            var newProgramVar = self.tmp
            let destinationVC = segue.destinationViewController as! detail1to1
            destinationVC.m_email = newProgramVar
        }
    }
}