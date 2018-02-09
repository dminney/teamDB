//
//  GetStartedViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/14/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {
    var appState = StateController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func FamilyButtonPressed(_ sender: Any) {
        appState.currentUser?.role = 0
         performSegue(withIdentifier: "createAccountSegue", sender: self)
    }
    

    @IBAction func CoachButtonPressed(_ sender: Any) {
        appState.currentUser?.role = 1
         performSegue(withIdentifier: "createAccountSegue", sender: self)
    }
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let DvC = segue.destination as! CreateUserViewController
        // Pass the selected object to the new view controller.
        DvC.appState = appState
        
    }
   

}
