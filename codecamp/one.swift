//
//  one.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 15/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class One: UIViewController {
    @IBOutlet weak var pick: UIPickerView!
    var secteur: String = "Informatique"
    var pickerDataSource = ["Informatique", "Sport", "Economie", "Audiovisuel", "Commerce", "Électronique", "Politique", "Mécanique", "Journalisme"];
    @IBOutlet weak var titre: UITextField!
    @IBOutlet weak var adresse: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var budget: UITextField!
    @IBOutlet weak var distance: UISlider!
    @IBOutlet weak var publique: UISwitch!
    @IBOutlet weak var viewdistance: UILabel!
    @IBOutlet weak var etat: UILabel!
    var bool:Int = 1
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datepicker.datePickerMode = .CountDownTimer
        datepicker.datePickerMode = .DateAndTime
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func verif() {
        let title = self.titre.text
        let adr = self.adresse.text
        let bud = self.budget.text
        if title!.characters.count < 3 {
            let alert = UIAlertController(title: "Titre", message:"Mettre 3 lettres ou plus", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else if adr!.characters.count < 3 {
            let alert = UIAlertController(title: "Adresse", message:"Mettre 3 lettres ou plus", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else if !isValidBudget(bud!){
            let alert = UIAlertController(title: "Budget", message:"Mettre au moins un nombre", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else {
            print("success")
            envoi()
        }
    }
    
    
    @IBAction func `switch`(sender: AnyObject) {
        if publique.on {
            bool = 1
            etat.text = "Publique"
            //publique.setOn(false, animated:true)
        } else {
            bool = 0
            etat.text = "Privée"
            //publique.setOn(true, animated:true)
        }
    }
        
    @IBAction func create(sender: AnyObject) {
        verif()
        print(bool)
    }
    
    @IBAction func slide(sender: AnyObject) {
        let value = distance.value
        let a:Int = Int(value)
        viewdistance.text = String(a) + "km"
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
    
    func isValidBudget(testStr:String) -> Bool {
        let emailRegEx = "^[0-9]{1,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    func envoi() {
        var now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        print(formatter.stringFromDate(datepicker.date))
        let strDate = formatter.stringFromDate(datepicker.date)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Tables/createTable1to1.php")!)
        print("1")
        let json: [String: AnyObject] = [
            "Email": defaults.stringForKey("Usermail")!,
            "Secteur": secteur,
            "Adresse": adresse.text!,
            "Titre": titre.text!,
            "Date": strDate,
            "Budget": budget.text!,
            "Distance": viewdistance.text!,
            "Public": bool
        ]
        let session = NSURLSession.sharedSession()
        print("2")
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
                        print("connected")
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
    
}
