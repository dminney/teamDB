//
//  LoginViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/13/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()
    var appState = StateController()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        checkifUserisLoggedIn()
    }

    func checkifUserisLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            let uid =  Auth.auth().currentUser?.uid
            appState.currentUser?.onlineid = uid!
            self.getTeamId(userid: uid! )
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if (emailTextField.text?.isEmpty)!{
            emailTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if (passwordTextField.text?.isEmpty)! {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        handlelogin(completion: {(userid) in
           self.appState.currentUser?.onlineid = userid
            self.getTeamId(userid: userid )
        })
    }
    
    func showSpinner () {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideSpinner (){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
   
    @IBOutlet weak var emailTextField: DesignableTextfield!
    @IBOutlet weak var passwordTextField: DesignableTextfield!
    
    
    func handlelogin(completion: @escaping (String) -> ()) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
        showSpinner()
            // [START headless_email_auth]
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // [START_EXCLUDE]
                self.hideSpinner()
                if error != nil {
                    print(error!)
                    return
                    }
                guard let uid = user?.uid else {
                    return
                }
                completion(uid)
                
                // TO DO :
                //  Finish setting all of the Current User, Current Team Info.
                // Eventually reload Database tables from Firebase Information.
              
                
                
                }
                // [END_EXCLUDE]
            }
            // [END headless_email_auth]
        else {
    //self.showMessagePrompt("email/password can't be empty")
    }
        
    }
    
    // MARK: - Navigation

    func launchFeedController() {
        
        let storyboard = UIStoryboard(name: "TabController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedTabController") as! CustomTabbarController
        vc.appState = self.appState
        present(vc, animated: true, completion: nil)
      //  self.navigationController!.pushViewController(vc, animated: true)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   
    func getTeamId (userid : String) {
               let teamRef = ref.child("UserTeams").queryOrdered(byChild: "user").queryEqual(toValue: userid)
                teamRef.observe(.value, with: { snapshot in
                    guard snapshot.exists() else{
                
                        print("Not following teams")
                        self.launchfindTeamController()
                        return
                    }
                    for snap in snapshot.children.allObjects as! [DataSnapshot] {

                        if let teamDict = snap.value as? [String : AnyObject] {
                            self.appState.currentTeam = (teamDict["team"] as! String)
                            self.getTeamInfo(teamid: self.appState.currentTeam!,completion: {() in
                                self.launchFeedController()
                            })
                        }
                    }
             
                })
        return
    }

    func getTeamInfo (teamid : String, completion: @escaping () -> Void ) {
        let teamRef = ref.child("Teams").child(teamid)
        teamRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            let value = snapshot.value as? NSDictionary
            self.appState.currentTeamName = value?["organization"] as? String ?? ""
             completion()
        }){ (error) in
            print(error.localizedDescription)
        }
       
        
    }
      //  teamRef.observeSingleEvent(of: .value, with: { (snapshot) in
     
        
    
    func launchfindTeamController() {
        performSegue(withIdentifier: "findTeamSegue", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "findTeamSegue" {
                let DvC = segue.destination as! FindYourTeamViewController
                DvC.appState = self.appState
            }
        }
    
}
