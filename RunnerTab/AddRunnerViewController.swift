//
//  AddPlayerViewController.swift
//  teamDB
//
//  Created by Dave Minney on 10/9/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddRunnerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let picker = UIDatePicker()
    var ref: DatabaseReference!
    var gender = true
    var active = true
    var runnerEntered : [DataSnapshot] = []
    var runneronlineid : String?
    var pickerData: [String] = [String]()
    var gradelevel : Int = 0
    var editmode : Bool = false
    var currentRunner : RunnerInfoModel? {
        didSet {
            navigationItem.title = (currentRunner?.firstname)! + " " + (currentRunner?.lastname)!
        }
    }
    
    
     // MARK: - Grade PickerView Setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                //   This method is triggered whenever the user makes a change to the picker selection.
                // The parameter named row and component represents what was selected.
                gradelevel = row
                gradeLabel.text = pickerData[row]
                self.gradepicker.isHidden = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.gradeLabel){
              self.gradepicker.isHidden = false
            textField.endEditing(true)
        }
    }
  
    // MARK: - Date Picker Setup
    
    func createDatePicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateLabel.inputAccessoryView = toolbar
        dateLabel.inputView = picker
        
        // format picker for Date
        
        picker.datePickerMode = .date
        
    }
    
    @objc func donePressed(){
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let datestring = formatter.string(from: picker.date)
        
        dateLabel.text = "\(datestring)"
        self.view.endEditing(true)
    }
    
    
    // MARK: - Main View Setup
    
    @IBOutlet weak var gradeLabel: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var gradepicker: UIPickerView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        pickerData = ["Elementary", "Junior High", "High School"]
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange])
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange])

       ref = Database.database().reference()
//        ref?.child("Runner").observe(.childAdded, with: {(snapshot) in
//        self.runnerEntered.append(snapshot)
//
//        })
        if editmode == true {
            firstNameField.text = currentRunner?.firstname
            lastNameField.text = currentRunner?.lastname
            emailField.text = currentRunner?.email
            phoneField.text = currentRunner?.phone
            dateLabel.text = currentRunner?.bdate
            gradeLabel.text = currentRunner?.grade  
            activeSwitch.setOn((currentRunner?.active)!, animated: false)
            
            if currentRunner?.gender == 0 {
            genderSwitch.setOn(false, animated: false)
                gender = false
            } else {
                genderSwitch.setOn(true, animated: false)
                gender = true
            }
        }
    
    }
    
    @IBAction func GenderSwitchChanged(_ sender: Any) {
        gender = !gender
    }
    
    @IBAction func ActiveSwitchChanged(_ sender: Any) {
        active = !active
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // ToDo : Post the Data to Firebase
        if (firstNameField.text?.isEmpty)! {
            firstNameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if (lastNameField.text?.isEmpty)! {
            lastNameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        currentRunner?.firstname = firstNameField.text!
        currentRunner?.lastname = lastNameField.text!
        currentRunner?.email = emailField.text
        currentRunner?.phone = phoneField.text
        currentRunner?.birthdate = dateLabel.text
        
       
        var gendernumber : Int
        
        if (gender){
            gendernumber = 1
        } else {
            gendernumber = 0
        }
        
        currentRunner?.gender = gendernumber
        currentRunner?.grade = gradeLabel.text
        currentRunner?.active = active
        
        
        if editmode == true {
            let runnerRef = ref.child("Runner").child(currentRunner!.onlineid)
     //       runnerRef.setValue(currentRunner)
            
            let id = DBAccessor.sharedInstance.updateRunner(runnerid: (currentRunner?.id)!, newRunner: currentRunner!)
                // Dismiss the Popover
                navigationController?.popViewController(animated: true)
                //  presentingViewController?.dismiss(animated: true, completion: nil)
            
        } else {
            let runnerRef = ref.child("Runner").childByAutoId()
            currentRunner?.onlineid = runnerRef.key
        //    runnerRef.setValue(currentRunner)
        
            if let id = DBAccessor.sharedInstance.addRunner(newRunner: currentRunner!){
                // Dismiss the Popover
                navigationController?.popViewController(animated: true)
                //  presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
        

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // Dismiss the Popover
        navigationController?.popViewController(animated: true)
        //presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAddPlayerViewControllerforRunner(runner : RunnerInfoModel ){
        currentRunner = runner
        firstNameField.text = currentRunner?.firstname
        lastNameField.text = currentRunner?.lastname
        emailField.text = currentRunner?.email
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
