//
//  inscription.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 13/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class inscription: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var pick: UIPickerView!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var metier: UITextField!
    var secteur: String = "Informatique"
    
    var pickerDataSource = ["Informatique", "Sport", "Economie", "Audiovisuel", "Commerce", "Électronique", "Politique", "Mécanique", "Journalisme"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        secteur = pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerDataSource[row]
        let Style = NSMutableParagraphStyle()
        Style.alignment = NSTextAlignment.Center
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 26.0)!,NSForegroundColorAttributeName:UIColor.whiteColor(), NSParagraphStyleAttributeName:Style])
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
    
    func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^0[6-7][0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    @IBAction func submit(sender: AnyObject) {
        verif()

    }
    
    func envoi() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/inscription2.php")!)
        let json: [String: AnyObject] = [
            "Secteur": secteur,
            "Metier": metier.text!,
            "Telephone": tel.text!,
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
                        self.defaults.setObject(self.secteur, forKey: "Secteur")
                        self.defaults.setObject(self.metier.text!, forKey: "Metier")
                        self.defaults.setObject(self.tel.text!, forKey: "Telephone")
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

    
    func verif() {
        let job = self.metier.text
        let phone = self.tel.text
        
        if !isValidPhone(phone!)
        {
            print("invalide phone number")
            let alert = UIAlertController(title: "Numéro de portable", message:"Ce numéro de portable est incorrecte", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        }
        else if job!.characters.count < 3 {
            let alert = UIAlertController(title: "Métier", message:"Mettre 3 lettres ou plus", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        }
        else
        {
            envoi()
            print("valide  ")
        }
    }
  
}