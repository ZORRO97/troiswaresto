//
//  NewRestoViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 28/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class NewRestoViewController: UIViewController {
    
    @IBOutlet var titleLabel : UILabel!
    
    var restos: [Resto]!
    var newResto : Resto!
    
    @IBAction func backButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
