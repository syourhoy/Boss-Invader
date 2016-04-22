//
//  deco.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 19/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class Deco: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print(Array(defaults.dictionaryRepresentation().keys).count)
        
        for key in Array(defaults.dictionaryRepresentation().keys) {
            defaults.removeObjectForKey(key)
        }
        
        print(Array(defaults.dictionaryRepresentation().keys).count)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("menu") as! menu
        dispatch_async(dispatch_get_main_queue()) {
            enum UIModalTransitionStyle : Int {
                case CrossDissolve
            }
            nextViewController.modalTransitionStyle = .CrossDissolve
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
    
}
