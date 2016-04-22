//
//  detailmixte.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 18/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class detailMixte: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var adr: UILabel!
    @IBOutlet weak var th: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var ins: UILabel!
 
    var m_email = String()
    var infos = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(m_email)
        getMixteTables()
    }

    func getMixteTables() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Tables/tableMixteInfo.php")!)
        let json: [String: AnyObject] = [
            "Email": m_email
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
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print(json["Adresse"] as! String)
                    print(json["Telephone"] as! String)
                    dispatch_async(dispatch_get_main_queue()) {
                    self.th.text = json["Theme"] as? String
                    self.adr.text = json["Adresse"] as? String
                    self.date.text = json["RDV"] as? String
                    let tel = json["Telephone"] as? String
                    self.tel.text = "0" + tel!
                    self.mail.text = json["Email"] as? String
                    let insc = json["Inscrits"] as? String
                    let par = json["Participants"] as? String
                    self.ins.text = "Participants: " + insc! + "/" + par!
                    self.th.font = UIFont (name: "HelveticaNeue", size: 18)
                    self.adr.font = UIFont (name: "HelveticaNeue", size: 12)
                    self.date.font = UIFont (name: "HelveticaNeue", size: 12)
                    self.tel.font = UIFont (name: "HelveticaNeue", size: 12)
                    self.mail.font = UIFont (name: "HelveticaNeue", size: 12)
                    self.ins.font = UIFont (name: "HelveticaNeue", size: 16)
                    }
                    // bonjour samir il faut que tu remplisses les label ici
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
    
    
    @IBAction func sit(sender: AnyObject) {
        recoit()
    }
    
    func recoit() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Tables/joinTableMixte.php")!)
        let json: [String: AnyObject] = [
            "Createur": mail.text!,
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
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    let retour = json["Etat"] as? Bool
                    if (retour == true) {
                        print(1)
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
        
        var alert = UIAlertController(title:"Succès",
                                      message:"Vous avez rejoint cette table",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let loginAction = UIAlertAction(title:"ok",
                                        style:UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                                            // HERE you perform the segue to your LoginVC,
                                            // or do whatever else you wanna do when the user clicked "Login" :)
                                            // for example:
                                            self.performSegueWithIdentifier("toHome2", sender:self)
        }
        
        alert.addAction(loginAction)
        self.presentViewController(alert, animated:true, completion:nil)
        
    }
    
    @IBAction func back(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        dispatch_async(dispatch_get_main_queue()) {
            enum UIModalTransitionStyle : Int {
                case CrossDissolve
            }
            nextViewController.modalTransitionStyle = .CrossDissolve
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}

    @IBAction func perso1(sender: AnyObject) {
        let alert = UIAlertController(title: "Adresse e-mail", message:"Cette adresse e-mail est déjà utilisée", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
}
