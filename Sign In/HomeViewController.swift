//
//  HomeViewController.swift
//  teamDB
//
//  Created by Dave Minney on 12/26/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import SQLite3
import Firebase

class HomeViewController: UIViewController {
        var appState = StateController(meet : "LCCC Fun Run", event : "HS Boys")
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appState.currentUser = appUserModel()
        //appState.createMeetList()
        // Do any additional setup after loading the view.
        checkifUserisLoggedIn()
        
    }
    
    func checkifUserisLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            let uid =  Auth.auth().currentUser?.uid
            appState.currentUser?.onlineid = uid!
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
           let DvC = segue.destination as! LoginViewController
                DvC.appState = self.appState
        }
        if segue.identifier == "GetStartedSegue"{
            let DvC = segue.destination as! GetStartedViewController
            DvC.appState = self.appState
       // let DvC = tabCtrl.viewControllers![0] as! MeetTableViewController
        // Pass the selected object to the new view controller.
        
        }
    }
  

}
