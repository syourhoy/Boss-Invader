//
//  profil.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 14/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Profil: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var prenom: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var metier: UILabel!
    @IBOutlet weak var secteur: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        someAff()
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
 
    func someAff() {
        let Usermail = defaults.stringForKey("Usermail")
        let Nom = defaults.stringForKey("Nom")
        let Prenom = defaults.stringForKey("Prenom")
        let Metier = defaults.stringForKey("Metier")
        let Telephone = "0" + defaults.stringForKey("Telephone")!
        let Secteur = defaults.stringForKey("Secteur")
        self.nom.text = Nom
        self.prenom.text = Prenom
        self.email.text = Usermail
        self.secteur.text = Secteur
        self.telephone.text = Telephone
        self.metier.text = Metier
        nom.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
        prenom.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
        email.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
        telephone.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
        metier.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
        secteur.font = UIFont (name: "HelveticaNeue-Thin", size: 15)
    }
    

    @IBAction func modif(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("modifpageview") as! ModifPageView
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
}
