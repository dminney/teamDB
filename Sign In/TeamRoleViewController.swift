//
//  TeamRoleViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/15/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit

class TeamRoleViewController: UIViewController {
   
    var appState = StateController()
    @IBOutlet weak var CoachingButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let role = appState.currentUser?.role{
        if role == 0 {
            CoachingButton.isHidden = true
        } else {
            CoachingButton.isHidden = false
        }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func coachButtonPressed(_ sender: UIButton) {
        appState.currentUser?.role = 1
        performSegue(withIdentifier: "createTeamSegue", sender: self)
    }
    
    @IBAction func fanButtonPressed(_ sender: UIButton) {
        appState.currentUser?.role = 3
        performSegue(withIdentifier:"findTeamSegue", sender: self)
    }
    
    @IBAction func runnerButtonPressed(_ sender: UIButton) {
        appState.currentUser?.role = 2
         performSegue(withIdentifier: "findTeamSegue", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createTeamSegue" {
            let DvC = segue.destination as! CreateTeamViewController
            DvC.appState = self.appState
        } else {
            if segue.identifier == "findTeamSegue" {
                let DvC = segue.destination as! FindYourTeamViewController
                DvC.appState = self.appState
        }
    }
  
    }
}
