//
//  WelcomeViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 06/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    @IBAction func ignoreButtonPressed(){
        self.performSegueWithIdentifier("tomainanonymous", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FirebaseHelper.createFirebaseUser("jeannemar@g.fr", password: "bidon")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
