//
//  AddEventViewController.swift
//  teamDB
//
//  Created by Dave Minney on 11/4/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class AddEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    let picker = UIDatePicker()
    let teampicker = UIPickerView()
    let genderpicker = UIPickerView()
    var meetid = Int64()
    var gradelevel = ["High School Varsity","High School Junior Varsity","High School Open","Middle School Varsity","Middle School Junior Varsity", "Middle School Open", "Elementary"]
    var gender = ["Female", "Male"]
    var currentEvent : EventDataModel?
    var ref: DatabaseReference!
    var appstate : StateController!
    var editmode = false
    var currentMeet : MeetDataModel?
    //var meetonlineid = String()
    var eventonlineid = String()
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var teamText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     ref = Database.database().reference()
        appstate = (tabBarController as! CustomTabbarController).appState!
        
        createDatePicker()
        createTeamPicker()
        createGenderPicker()
        
        teampicker.delegate = self
        teampicker.dataSource = self
        genderpicker.delegate = self
        genderpicker.dataSource = self
        
        // Do any additional setup after loading the view.
        teamText.inputView = teampicker
        genderText.inputView = genderpicker
        
        teamText.attributedPlaceholder = NSAttributedString(string: "Competing Team",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        titleLabel.attributedPlaceholder = NSAttributedString(string: "Event Title",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        dateLabel.attributedPlaceholder = NSAttributedString(string: "00:00 AM",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
        
        if editmode == true {
            titleLabel.text = currentEvent?.name
            dateLabel.text = currentEvent?.time
            teamText.text = currentEvent?.team
            genderText.text = gender[(currentEvent?.gender)!]
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        let event_name = titleLabel.text
        let event_time = dateLabel.text
        let event_team = teamText.text
        var event_genderpicked : Int
        let school : String
        
       
        
        switch event_team  {
        case gradelevel[0]? , gradelevel[1]? , gradelevel[2]? :
         school = "High School"
        case gradelevel[3]? , gradelevel[4]? ,gradelevel[5]? :
            school = "Junior High"
        case gradelevel[6]? :
            school = "Elementary"
        default :
            school = "High School" }
        
        if genderText.text == gender[0]{
            event_genderpicked = 0
        } else {
            event_genderpicked = 1
        }

      //  let newEvent : Dictionary = ["name":event_name!, "time":event_time!,"team":event_team!,"gender":event_genderpicked,"meet":meetonlineid, "grade":school] as [String : Any]
       
        if editmode == true {
            try! uiRealm.write {
                currentEvent?.name = event_name!
                currentEvent?.time = event_time!
                currentEvent?.team = event_team!
                currentEvent?.grade = school
                currentEvent?.gender = event_genderpicked
            }
            
  //     let Dbic = DBAccessor.sharedInstance.updateEvent(eventid: (currentEvent?.id)!, newEvent: updatedEvent)
  //          if Dbic {
            
            navigationController?.popViewController(animated: true)
  //          }
            
        } else {
            if let selectedMeet = self.currentMeet {
                
                do {
                    try uiRealm.write {
                        let nowdate = Date()
                        let datestring = "\(nowdate.timeIntervalSince1970))"
                        let updatedEvent = EventDataModel(
                            name: event_name!,
                            gender: event_genderpicked,
                            time: event_time!,
                            team: event_team!,
                            grade: school)
                        updatedEvent.updated_at = datestring
                        selectedMeet.events.append(updatedEvent)
                        //uiRealm.add(self, update: true)
                    }
                } catch {
                    print("Error saving new Event")
                }
                
               // updatedEvent.writeToRealm()
            }
          //  let eventRef = ref.child("Event").childByAutoId()
          //  eventRef.setValue(newEvent)
          //  eventonlineid = eventRef.key
          //  let Dbid = DBAccessor.sharedInstance.addEvent(eventname: event_name!, onlineid: eventonlineid, eventmeet: meetonlineid, eventtime: event_time!, eventteam: event_team!, eventgender: event_genderpicked, eventgrade: school)
           // if Dbid! >= 0 {
                navigationController?.popViewController(animated: true)
          //  }
        }

    
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = 0
        if pickerView == teampicker{
            count = gradelevel.count}
        else if pickerView == genderpicker {
            count = gender.count}
    return count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       var rowString = ""
        if pickerView == teampicker{
           rowString = gradelevel[row]
        }
        else if pickerView == genderpicker {
            rowString = gender[row]}
        return rowString
        
}
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == teampicker{
//            teamText.text = gradelevel[row]
//        }
//        else if pickerView == genderpicker {
//            genderText.text = gender[row]}
            }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
        
        picker.datePickerMode = .time
        
    }
    
    @objc func donePressed(){
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let datestring = formatter.string(from: picker.date)
        
        dateLabel.text = "\(datestring)"
        self.view.endEditing(true)
    }
    
    
    func createTeamPicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneteamPressed))
        toolbar.setItems([done], animated: false)
        
       teamText.inputAccessoryView = toolbar
        teamText.inputView = teampicker
        
    }
    
    @objc func doneteamPressed(){
        // format date
        let row = teampicker.selectedRow(inComponent:0)
       teamText.text = gradelevel[row]
        self.view.endEditing(true)
    }
    
    func createGenderPicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donegenderPressed))
        toolbar.setItems([done], animated: false)
        
        genderText.inputAccessoryView = toolbar
        genderText.inputView = teampicker
        
    }
    
    @objc func donegenderPressed(){
        
        let row = genderpicker.selectedRow(inComponent:0)
        genderText.text = gender[row]
        self.view.endEditing(true)
    }


    
}
