//
//  ViewController.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 11/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    @IBAction func back(sender: AnyObject) {
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("menu") as! menu
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }*/
    }

    func verif() {
        let firstnamef = self.firstname.text
        let passwordf = self.password.text
        let emailf = self.email.text
        let lastnamef = self.lastname.text
        
        if firstnamef!.characters.count < 2 {
            let alert = UIAlertController(title: "Prénom", message:"Doit contenir 2 lettres au minimum", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        else if  lastnamef!.characters.count < 2 {
            let alert = UIAlertController(title: "Nom", message:"Doit contenir 2 lettres au minimum", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else if !isValidEmail(emailf!) {
            let alert = UIAlertController(title: "Email", message:"Veuillez entrer une adresse mail correcte", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        else if  passwordf!.characters.count < 3 {
            let alert = UIAlertController(title: "Mot de passe", message:"Votre mot de passe doit être composé d'au moins 3 caractères", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        else
        {
            envoi()
            print("no errors during signup")
        }
    }
    
    func envoi() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/inscription1.php")!)
        let json: [String: AnyObject] = [
            "Nom":lastname.text!,
            "Prenom":firstname.text!,
            "Email":email.text!,
            "Password":password.text!
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
                    let retour = json["Erreur"] as? String
                    if (retour != nil) {
                        print("test")
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "Adresse e-mail", message:"Cette adresse e-mail est déjà utilisée", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                            self.presentViewController(alert, animated: true){}
                        })
                    } else {
                        // enregistrement des données en local
                        self.defaults.setObject(self.email.text!, forKey: "Usermail")
                        self.defaults.setObject(self.lastname.text!, forKey: "Nom")
                        self.defaults.setObject(self.firstname.text, forKey: "Prenom")
                        self.defaults.setObject(self.password.text!, forKey: "Password")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("inscription2") as! inscription
                        dispatch_async(dispatch_get_main_queue()) {
                            enum UIModalTransitionStyle : Int {
                                case CrossDissolve
                            }
                            nextViewController.modalTransitionStyle = .CrossDissolve
                            self.presentViewController(nextViewController, animated:true, completion:nil)
                        }
                        
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
    
    
    @IBAction func sendSignup(sender: UIButton) {
        verif()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
        
    }
    
  

}

