
//
//  CreateTeamViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/15/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
import Firebase


class CreateTeamViewController: UIViewController {

    @IBOutlet weak var organizationField: UITextField!
    @IBOutlet weak var teamNameField: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    
    
    var appState = StateController()
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
      
    }

    func createTeam(){
       
            guard let organization = organizationField.text else {
                return }
            guard let teamname = teamNameField.text else {
                return }
            guard let postcode = postalCodeField.text else {
                return }
            guard let city = cityField.text else {
                return }
            guard let state = stateField.text else {
                return }
        let newteam = ["organization": organization, "mascot": teamname, "city": city, "state": state, "zipcode": postcode]
        let TeamRef = self.ref.child("Teams").childByAutoId()
        TeamRef.updateChildValues(newteam, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            self.appState.currentTeam = TeamRef.key
            self.matchUserAndTeam()
        })
        
        
    }
 
    func matchUserAndTeam() {
        guard let team = appState.currentTeam else {
            return
        }
        guard let user = appState.currentUser?.onlineid else {
            return
        }
        
        let newteam = ["team": team, "user": user]
        let TeamRef = self.ref.child("UserTeams").childByAutoId()
        TeamRef.updateChildValues(newteam, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    
    @IBAction func createTeamButtonPressed(_ sender: Any) {
        if (organizationField.text?.isEmpty)! {
            organizationField.layer.borderWidth = 2
            organizationField.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            organizationField.layer.borderWidth = 0
        }
        if (postalCodeField.text?.isEmpty)! {
            postalCodeField.layer.borderWidth = 2
            postalCodeField.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            postalCodeField.layer.borderWidth = 0
        }
        if (cityField.text?.isEmpty)! {
            cityField.layer.borderWidth = 2
            cityField.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            cityField.layer.borderWidth = 0
        }
        if (stateField.text?.isEmpty)! {
            stateField.layer.borderWidth = 2
            stateField.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            stateField.layer.borderWidth = 0
        }
        
        createTeam()
    
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
     //   let DvC = segue.destination as
        // Pass the selected object to the new view controller.
       //  DvC.appState = appState
    }
    

}
