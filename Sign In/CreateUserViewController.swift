//
//  CreateUserViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/14/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateUserViewController: UIViewController {
    var appState = StateController()
    var newAppUser = appUserModel()
    var ref: DatabaseReference!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

 
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if (firstNameField.text?.isEmpty)! {
                firstNameField.layer.borderColor = UIColor.red.cgColor
                firstNameField.layer.borderWidth = 2.0
            return
        } else {
             firstNameField.layer.borderWidth = 0
        }
        if (lastNameField.text?.isEmpty)!{
            lastNameField.layer.borderColor = UIColor.red.cgColor
            lastNameField.layer.borderWidth = 2.0
            return
        } else {
            lastNameField.layer.borderWidth = 0
        }
        
        if (emailField.text?.isEmpty)!{
            emailField.layer.borderColor = UIColor.red.cgColor
            emailField.layer.borderWidth = 2.0
            return
        } else {
            emailField.layer.borderWidth = 0
        }
        if (passwordField.text?.isEmpty)!{
            passwordField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 2.0
            return
        } else {
             passwordField.layer.borderWidth = 0
        }
        
        // to Do:  Check Password for length.
        //         Check Email for correct format.
        
        createUser()
        
        
    }
    
    
    func createUser(){
        guard let firstname = firstNameField.text else {
            return }
        guard let lastname = lastNameField.text else {
            return  }
        guard let email = emailField.text else {
            return  }
        guard let password = passwordField.text else {
            return }
     
        newAppUser.firstname = firstname
        newAppUser.lastname = lastname
        newAppUser.email = email
        
        
        // TO DO:
        // look to validate that email is of format for email before proceeding
        // if user creation fails need to pop a message out to User.
        var result = 1
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
        
            if error != nil {
                print(error!)
                result = 0
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            // successfully created an authenticated user
            let newuser = ["first name": firstname, "last name": lastname, "email": email]
            let UserRef = self.ref.child("Users").child(uid)
            UserRef.updateChildValues(newuser, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    result = 0
                    return
                }
            })
            self.newAppUser.role = self.appState.currentUser?.role
            self.newAppUser.onlineid = uid
            self.appState.currentUser = self.newAppUser
            if result > 0 {
                self.performSegue(withIdentifier: "teamRoleSegue", sender: self)
            }
        })
        return
    }

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DvC = segue.destination as! TeamRoleViewController
        // Pass the selected object to the new view controller.
        DvC.appState = appState
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   

}
