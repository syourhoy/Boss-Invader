//
//  tablemixte.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 15/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Mixte: UIViewController {

    @IBOutlet weak var pick: UIPickerView!
    @IBOutlet weak var thematique: UITextField!
    @IBOutlet weak var adresse: UITextField!
    @IBOutlet weak var datepick: UIDatePicker!
    var pickerDataSource = ["3", "4", "5", "6", "7", "8", "9", "10"];
    var Nbr: String = "3"
    let defaults = NSUserDefaults.standardUserDefaults()

    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepick.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datepick.datePickerMode = .CountDownTimer
        datepick.datePickerMode = .DateAndTime
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    @IBAction func create(sender: AnyObject) {
        let theme = self.thematique.text
        let adr = self.adresse.text
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(datepick.date)
        
        
        if theme!.characters.count < 3 {
            let alert = UIAlertController(title: "Thematique", message:"Mettre 3 lettres ou plus", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        }   else if adr!.characters.count < 3 {
            let alert = UIAlertController(title: "Adrresse", message:"Mettre 3 lettres ou plus", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else {
            envoi()
            print(Nbr)
            print("valide  ")
        }
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
        Nbr = pickerDataSource[row]
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
    
    func envoi() {
   
        var now = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        print(formatter.stringFromDate(datepick.date))
        var strDate = formatter.stringFromDate(datepick.date)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://bossinvaderapi-guimeus.c9users.io/serveur/Tables/createTableMixte.php")!)
        print("1")
        let json: [String: AnyObject] = [
            "Email": defaults.stringForKey("Usermail")!,
            "Participants": Nbr,
            "Theme": thematique.text!,
            "Adresse": adresse.text!,
            "Date": strDate
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
    
   
}
    
   

