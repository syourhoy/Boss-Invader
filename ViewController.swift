//
//  ViewController.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 11/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    
    @IBAction func register(sender: AnyObject) {
        
            let firstnamef = self.firstname.text
            let passwordf = self.password.text
            let emailf = self.email.text
            let lastnamef = self.lastname.text
        
            if firstnamef!.characters.count < 3 {
                let alert = UIAlertView(title: "Prenom", message: "3 lettres mininum", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else if  lastnamef!.characters.count < 4 {
                let alert = UIAlertView(title: "Nom de famille", message: "4 lettres minimum", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else if !isValidEmail(emailf!)
            {
                print("invalide email")
                let alert = UIAlertView(title: "email", message: "Mail invalide(nom@hotmail.fr)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else if  passwordf!.characters.count < 6 {
                let alert = UIAlertView(title: "Mot de passe", message: "6 lettres minimum", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else
            {
                print("valide email")
            }
        }

}

