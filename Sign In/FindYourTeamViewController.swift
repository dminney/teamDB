//
//  FindYourTeamViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/15/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
import Firebase

class FindYourTeamViewController: UIViewController {
    
    var appState = StateController()
    var ref : DatabaseReference!
    var teamList = [TeamInfoModel]()
    
    @IBOutlet weak var organizationField: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }


    @IBAction func findTeamButtonPressed(_ sender: Any) {
        if organizationField.text?.isEmpty == true {
            if postalCodeField.text?.isEmpty != true {
                let zipcode = Int (postalCodeField.text!)
                findTeamswithZipcode(zipcode: zipcode!)
            }
        } else {
            guard let teamname = organizationField.text else {
                return
            
            }
            findTeamswithName(teamName: teamname)
        }
    }
    
    func findTeamswithName(teamName: String) {
        
                let teamRef = ref.child("Teams").queryOrdered(byChild: "organization").queryEqual(toValue: teamName)
        
                teamRef.observe(.value, with: { snapshot in
        
                    for snap in snapshot.children.allObjects as! [DataSnapshot] {
                        if let teamDict = snap.value as? [String:AnyObject] {
                            let teamid = snap.key
                            let teamInfo = TeamInfoModel(id: teamid, teamData: teamDict)
                            self.teamList.append(teamInfo)
                        }
                    }
        
                })
    
    }
    
    func findTeamswithZipcode(zipcode: Int) {
        let zip = String(zipcode) 
        
        let teamRef = ref.child("Teams").queryOrdered(byChild: "zipcode").queryEqual(toValue: zip)
        
        teamRef.observe(.value, with: { snapshot in
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if let teamDict = snap.value as? [String:AnyObject] {
                    let teamid = snap.key
                    let teamInfo = TeamInfoModel(id: teamid, teamData: teamDict)
                    self.teamList.append(teamInfo)
                }
            }
            
        self.performSegue(withIdentifier: "showTeamsFoundSegue", sender: self)
        })
        
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let DvC = segue.destination as! TeamsFoundViewController
        // Pass the selected object to the new view controller.
        DvC.teamList = teamList
        DvC.appState = appState
    }
    
}
