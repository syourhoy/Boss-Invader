//
//  modify.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 14/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Modify: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var metier: UITextField!
    @IBOutlet weak var secteur: UIPickerView!
    var data: String = "Informatique"
    var pickerDataSource = ["Informatique", "Sport", "Economie", "Audiovisuel", "Commerce", "Électronique", "Politique", "Mécanique", "Journalisme"];
    
   
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^0[0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        someAff()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func envoi() {
        let pass = defaults.stringForKey("Password")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Profil/updateUser.php")!)
        let json: [String: AnyObject] = [
            "Secteur": data,
            "Metier": metier.text!,
            "Telephone": telephone.text!,
            "Email": defaults.stringForKey("Usermail")!,
            "Password": pass!
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
                        self.defaults.setObject(self.data, forKey: "Secteur")
                        self.defaults.setObject(self.metier.text!, forKey: "Metier")
                        self.defaults.setObject(self.telephone.text!, forKey: "Telephone")
                        /*self.defaults.setObject(self.confirm.text!, forKey: "Password")*/
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
        let job = self.metier.text
        let phone = self.telephone.text
       
        if !isValidPhone(phone!)
        {
            print("invalide phone number")
            let alert = UIAlertController(title: "Numero de telephone", message:"Ce numero de telephone est incorrecte", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        else if job!.characters.count < 3 {
            let alert = UIAlertController(title: "Metier", message:"Mettre 3 lettres ou plus", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        }
        else
        {
            envoi()
            let alert = UIAlertController(title: "Informations", message:"Modification réussie", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            print("valide  ")
        }
    }
    
    
    func someAff() {
        let Telephone = defaults.stringForKey("Telephone")
        self.telephone.text = "0" + Telephone!
        let Metier = defaults.stringForKey("Metier")
        self.metier.text = Metier
        metier.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
        telephone.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
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
        data = pickerDataSource[row]
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
    
    @IBAction func modif(sender: AnyObject) {
        verif()
    }
}
