//
//  AddResultsViewController.swift
//  teamDB
//
//  Created by Dave Minney on 11/15/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AddResultsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var meetText: UITextField!
    @IBOutlet weak var eventText: UITextField!
    @IBOutlet weak var runnerText: UITextField!
    @IBOutlet weak var mile1Text: UITextField!
    @IBOutlet weak var mile2Text: UITextField!
    @IBOutlet weak var finishTimeText: UITextField!
    
    let meetpicker = UIPickerView()
    let eventpicker = UIPickerView()
    let runnerpicker = UIPickerView()
    var meetlist = [MeetModel]()
    var ref: DatabaseReference!
    var meetonlineid : String?
    var eventList = [EventInfoModel]()
    var eventgender : Int?
    var runnerlist = [RunnerInfoModel]()
    var delegate : DataSentDelegate? = nil
    var lastrow : Int = 0
    var meetrow : Int = 0
    var eventid:  String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetpicker.delegate = self
        meetpicker.dataSource = self
        eventpicker.delegate = self
        eventpicker.dataSource = self
        runnerpicker.delegate = self
        runnerpicker.dataSource = self
        
        // set the text fields to use pickerviews as Input
       // meetText.inputView = meetpicker
        
        // Gather the list of meets for Picker View
        ref = Database.database().reference()
        
        meetlist.removeAll()
        meetlist = DBAccessor.sharedInstance.getMeets()
//        ref?.child("Meet").observe(.childAdded, with: {(snapshot) in
//            let id = snapshot.key as String
//            if let meetshownDictionary  = snapshot.value as?[String:AnyObject]{
////                let meetInfo = MeetModel(id: id, meetData: meetshownDictionary)
////                self.meetlist.append(meetInfo)
//            }
//        })

        createMeetPicker()
         createEventPicker()
        createRunnerPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Only need 1 column to be selected in Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // determine number of items in Pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = 0
        if pickerView == meetpicker{
            count = meetlist.count}
        else if pickerView == eventpicker {
            count = eventList.count}
        else if pickerView == runnerpicker {
            count = runnerlist.count}
        return count
    }
    
    // populate Picker View with Row String
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowString = ""
        if pickerView == meetpicker{
            rowString = meetlist[row].name
        }
        else if pickerView == eventpicker {
            rowString = eventList[row].name}
        else if pickerView == runnerpicker {
            let firstName = runnerlist[row].firstname
            let lastName = runnerlist[row].lastname
            rowString = "\(firstName) \(lastName)"}
        return rowString
        
    }
    
    
// Create Meet Picker -
//      Update Picker Roll with Names of meets
// add done button to use picker selection
    func createMeetPicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donemeetPressed))
        toolbar.setItems([done], animated: false)
        
        meetText.inputAccessoryView = toolbar
        meetText.inputView = meetpicker
        
    }
    
    @objc func donemeetPressed(){
        // format date
        let row = meetpicker.selectedRow(inComponent:0)
        meetText.text = meetlist[row].name
        meetonlineid = meetlist[row].onlineid
        self.view.endEditing(true)
         createEventList()
        DispatchQueue.main.async(){
            self.eventpicker.reloadAllComponents()
        }
    }
    
    
// Create Event Picker
//      query meet for Event List to populate Picker Roll
//      add done button to use picker selection
    func createEventPicker(){
       
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEventPressed))
        toolbar.setItems([done], animated: false)
        
        eventText.inputAccessoryView = toolbar
        eventText.inputView = eventpicker
        
    }
    
    @objc func doneEventPressed(){
        // format date
        let row = eventpicker.selectedRow(inComponent:0)
        if !eventList.isEmpty{
            eventText.text = eventList[row].name
            eventgender = eventList[row].gender
            eventid = eventList[row].onlineid
        }
        self.view.endEditing(true)
        createRunnerList()
        DispatchQueue.main.async(){
            self.runnerpicker.reloadAllComponents()}
    }
    
// Create EventList by querying based on Meet selected
    
    func createEventList(){
    
        if meetonlineid != "" {
            eventList = DBAccessor.sharedInstance.getEvents(meetid: meetonlineid!)}
        
//        let eventRef = ref.child("Event").queryOrdered(byChild: "meet").queryEqual(toValue: meetid)
//            eventlist.removeAll()
//        eventRef.observe(.value, with: { snapshot in
//            
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                let key = snap.key as String
//                if let eventDict = snap.value as? [String:AnyObject] {
//                    let eventInfo = EventInfoModel(id: key, eventData: eventDict)
//                    self.eventlist.append(eventInfo)
//                }
//            }
//           
//        })
    }
    
// Create Runner Picker
// use the gender and Grade to build the list for the Picker Roll
    // Create Event Picker
    //      query meet for Event List to populate Picker Roll
    //      add done button to use picker selection
    func createRunnerPicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneRunnerPressed))
        toolbar.setItems([done], animated: false)
        
        runnerText.inputAccessoryView = toolbar
        runnerText.inputView = runnerpicker
        
    }
    
    @objc func doneRunnerPressed(){
        // format date
        let row = runnerpicker.selectedRow(inComponent:0)
        if !eventList.isEmpty{
            let firstName = runnerlist[row].firstname
            let lastName = runnerlist[row].lastname
            runnerText.text = "\(firstName) \(lastName)"
            lastrow = row
        }
        self.view.endEditing(true)
    }
    
    // Create RunnerList by querying based on gender of event selected
    
    func createRunnerList(){
        
//        let runnerRef = ref.child("Runner").queryOrdered(byChild: "gender").queryEqual(toValue: eventgender)
        runnerlist.removeAll()
        runnerlist = DBAccessor.sharedInstance.getAllRunners()
//
//        runnerRef.observe(.value, with: { snapshot in
//
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                let id = snap.key as String
//                if let runnerDict = snap.value as? [String:AnyObject] {
//                    let runnerInfo = RunnerInfoModel(id:id , runnerData: runnerDict)
//                    self.runnerlist.append(runnerInfo)
//                }
//            }
//
//        })
    }
    func minutesSecondsInterval(_ timeString:String)->TimeInterval!{
        let time = timeString.components(separatedBy: ":")
        if let seconds = Double(time[1]){
            if let minutes = Double(time[0]){
                return (seconds + (minutes * 60.0))
            }
        }
        return nil
    }
// Save Button Pressed
    // read Text Fields and store Text into Database with Runner Results
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var mile1time : Double = 0
        var mile2time : Double = 0
        var finishtime : Double = 0
        
        if !(mile1Text.text?.isEmpty)! {
            mile1time = minutesSecondsInterval(mile1Text.text!) }
        
        if !(mile2Text.text?.isEmpty)! {
            mile2time = minutesSecondsInterval(mile2Text.text!) }
        
        if !(finishTimeText.text?.isEmpty)! {
            finishtime = minutesSecondsInterval(finishTimeText.text!) }
        
        DBAccessor.sharedInstance.addResult(resultEventID: eventid!, resultRunnerID: runnerlist[lastrow].onlineid, resultMile1Time: mile1time, resultMile2Time: mile2time, resultFinalTime: finishtime, resultmeetid: meetonlineid!)
        
        let result : Dictionary = ["meet":meetonlineid as AnyObject, "event":eventid as AnyObject,"runner":runnerlist[lastrow].id!, "mile1":mile1time as Any, "mile2": mile2time as Any, "final":finishtime as Any] as [String : AnyObject]
        
//        if delegate != nil {
//            if resultid != "" {
//                ref?.child("Result").child(meetid).setValue(meet)
//                delegate?.userDidEnterData(data: result, id:meetid, row:lastrow)
//            }
//            else {
                ref?.child("Result").childByAutoId().setValue(result)
                
   //         }
            
   //     }
           navigationController?.popViewController(animated: true)
        
    //    dismiss(animated: true, completion: nil)
    }
    
    
    
// Cancel Button Pressed
    @IBAction func cancelButtonPressed(_ sender: Any) {
        eventText.text = ""
        meetText.text = ""
        runnerText.text = ""
        mile1Text.text = ""
        mile2Text.text = ""
        finishTimeText.text = ""
    //  Clear out Text Fields
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
