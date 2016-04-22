//
//  File.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 12/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Connexion: UIViewController {
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var button: UIButton!
    
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
    
    
    @IBAction func connect(sender: AnyObject) {
        let mailf = self.mail.text
        let passwordf = self.password.text
        
        if !isValidEmail(mailf!)
        {
            print("invalide email")
            let alert = UIAlertView(title: "email", message: "Mail invalide(nom@hotmail.fr)", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else if passwordf!.characters.count < 6 {
            let alert = UIAlertView(title: "Mot de passe", message: "6 lettres minimum", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else
        {
            print("Valide email")
        }
    }
}