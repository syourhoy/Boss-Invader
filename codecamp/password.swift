//
//  password.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 17/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Password: UIViewController {
    @IBOutlet weak var old: UITextField!
    @IBOutlet weak var new: UITextField!
    @IBOutlet weak var confirm: UITextField!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func envoi() {
        let data = defaults.stringForKey("Secteur")
        let met = defaults.stringForKey("Metier")
        let tel = defaults.stringForKey("Telephone")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Profil/updateUser.php")!)
        let json: [String: AnyObject] = [
            "Secteur": data!,
            "Metier": met!,
            "Telephone": tel!,
            "Email": defaults.stringForKey("Usermail")!,
            "Password": confirm.text!
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
                print("oui")
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    let retour = json["Etat"] as? Bool
                    if (retour == true) {
                      /*  self.defaults.setObject(self.data, forKey: "Secteur")
                        self.defaults.setObject(self.metier.text!, forKey: "Metier")
                        self.defaults.setObject(self.telephone.text!, forKey: "Telephone")*/
                        self.defaults.setObject(self.confirm.text!, forKey: "Password")
                        print("yes")
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
    
    func verif() {
        var oldtext = self.old.text
        var newtext = self.new.text
        var conftext = self.confirm.text
        let pass = defaults.stringForKey("Password")
        
         if oldtext! != pass! {
         let alert = UIAlertController(title: "Ancien mot de passe", message:"Mot de passe introuvable", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
         self.presentViewController(alert, animated: true){}
         }
         else if oldtext!.characters.count < 3 {
         let alert = UIAlertController(title: "Ancien mot de passe", message:"Mot de passe trop court", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
         self.presentViewController(alert, animated: true){}
         }
         else if newtext! == pass! {
         let alert = UIAlertController(title: "Nouveau mot de passe", message:"Mot de passe identique a l'ancien", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
         self.presentViewController(alert, animated: true){}
         }
         else if newtext!.characters.count < 3 {
         let alert = UIAlertController(title: "Nouveau mot de passe", message:"Mot de passe trop court", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
         self.presentViewController(alert, animated: true){}
         }
         else if conftext! != newtext! {
         let alert = UIAlertController(title: "confirmer mot de passe", message:"Mot de passe different", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
         self.presentViewController(alert, animated: true){}
         }
         else if conftext!.characters.count < 3 {
         let alert = UIAlertController(title: "Nouveau mot de passe", message:"Mot de passe trop court", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
         self.presentViewController(alert, animated: true){}
         }
        else
        {
            envoi()
            let alert = UIAlertController(title: "Mot de passe", message:"Modification réussie", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            print("valide  ")
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    @IBAction func modif(sender: AnyObject) {
        verif()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
