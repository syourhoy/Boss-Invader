//
//  connexion.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 13/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class connexion: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    @IBAction func back(sender: AnyObject) {
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("menu") as! menu
        dispatch_async(dispatch_get_main_queue()) {
            enum UIModalTransitionStyle : Int {
                case CrossDissolve
            }
            nextViewController.modalTransitionStyle = .CrossDissolve
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        var contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
        
    }
    
    func verif () {
        let passf = self.pass.text
        let mailf = self.mail.text
      //  let passd = defaults.stringForKey("Password")
        if !isValidEmail(mailf!) {
            let alert = UIAlertController(title: "Email", message:"Veuillez entrer une adresse mail correcte", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){ }
        }
        else if  passf!.characters.count < 3 {
            let alert = UIAlertController(title: "Mot de passe", message:"Votre mot de passe doit être composé d'au moins 3 caractères", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){ }
        }
        else
        {
            envoi()
        }
    }
    
    func envoi() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/connexion.php")!)
        let json: [String: AnyObject] = [
            "Email": mail.text!,
            "Password": pass.text!
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
                    let state = json["Etat"] as? Bool
                    if ((state) != false) {
                        self.defaults.setObject(self.mail.text!, forKey: "Usermail")
                        self.defaults.setObject(self.pass.text!, forKey: "Password")
                        self.defaults.setObject(json["Data"]!["Nom"], forKey: "Nom")
                        self.defaults.setObject(json["Data"]!["Prenom"], forKey: "Prenom")
                        self.defaults.setObject(json["Data"]!["Adresse"], forKey: "Adresse")
                        self.defaults.setObject(json["Data"]!["Metier"], forKey: "Metier")
                        self.defaults.setObject(json["Data"]!["Secteur"], forKey: "Secteur")
                        self.defaults.setObject(json["Data"]!["Telephone"], forKey: "Telephone")
                        print(data)
                        self.defaults.synchronize()
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
    
    @IBAction func connect(sender: AnyObject) {
        verif()


    }
}
