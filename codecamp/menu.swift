//
//  menu.swift
//  codecamp
//
//  Created by Samir ABOU BEKR on 13/04/16.
//  Copyright © 2016 Samir ABOU BEKR. All rights reserved.
//

import UIKit

class menu: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {return .LightContent}
    
    @IBAction func inscription(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("inscription") as! ViewController
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
    
    @IBAction func connection(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("connection") as! connexion
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
    
}