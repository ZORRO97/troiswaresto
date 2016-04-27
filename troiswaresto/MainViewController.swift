//
//  MainViewController.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    var restos = [Resto]()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "torestos" {
            let myDestination : RestosViewController = segue.destinationViewController as! RestosViewController
            myDestination.restos = restos
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myRootRef = Firebase(url:"https://sweltering-heat-2058.firebaseio.com")
        
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            logDebug("back from request")
            logDebug("\(snapshot.key) -> \(snapshot.value)")
        })
        
        getRestosInfo() { (allRestos) in
            self.restos = allRestos
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

