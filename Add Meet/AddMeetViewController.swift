//
//  AddMeetViewController.swift
//  teamDB
//
//  Created by Dave Minney on 10/30/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseDatabase
import RealmSwift

protocol DataSentDelegate {
    
    func userDidEnterData (data:Dictionary<String , AnyObject>, id: String, row: Int)
}

class EventCell : UITableViewCell {
    
    

    @IBOutlet weak var eventTitle: UILabel!

    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    
    
}



class AddMeetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    var delegate : DataSentDelegate? = nil
    var meetid : Int64?
    var meetonlineid : String = ""
    var selectedrow : Int = 0
    var eventList  : Results<EventDataModel>!
    var appstate : StateController!
    var oldMeets = [MeetDataModel]()
   // let meetpicker = UIPickerView()
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var EventTableView: UITableView!
    @IBOutlet weak var meetpicker: UIPickerView!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    
 //   var ref: DatabaseReference!
    let picker = UIDatePicker()
    var meetinfo : MeetDataModel?
    var eventinfo : EventDataModel?
    var eventRowSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventTableView.delegate = self
        EventTableView.dataSource = self
 //       meetpicker.delegate = self
 //       meetpicker.dataSource = self
        appstate = (tabBarController as! CustomTabbarController).appState!
        createDatePicker()
     
        // Initial Setup of Default Text Labels
   
       
       
    }
    func configureCells(){
        
        titleLabel.text = meetinfo?.name
        locationLabel.text = meetinfo?.address
        cityLabel.text = meetinfo?.city
        stateLabel.text = meetinfo?.state
        zipCodeLabel.text = meetinfo?.zipcodeString()
        dateLabel.text = meetinfo?.date
        // meetonlineid = meetinfo.onlineid
    }

    override func viewWillAppear(_ animated: Bool) {
        eventRowSelected = false
        attemptReloadofTableView()
        configureCells()
    }
    
    // MARK: PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerData.count
//    }
//    // The data to return for the row and component (column) that's being passed in
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return oldMeets.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        var rowString = ""
//        self.view.endEditing(true)
//        rowString = oldMeets[row].name
//
//        return rowString
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.titleLabel.text = oldMeets[row].name
        self.meetpicker.isHidden = true
    }
    
    @IBAction func titleDidBeginEditing(_ sender: UITextField) {
            self.meetpicker.isHidden = false
    }
    
    

    
      // MARK: - TableView
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList?.count ?? 0
        
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventTableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        eventinfo = self.eventList[indexPath.row]
        let eventName = eventinfo?.name
        let eventTime = eventinfo?.time
        cell.eventTitle.text = eventName
        cell.eventTimeLabel.text = eventTime

        let runnerButton = UIButton(type: .custom) as UIButton
            runnerButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            runnerButton.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
            runnerButton.setImage(#imageLiteral(resourceName: "cc-runner"), for: .normal)
            runnerButton.tag = indexPath.row
        cell.accessoryView = runnerButton as UIView
        return cell
    }
    
    
 @objc func accessoryButtonTapped(sender:UIButton){
    
        let indexPath = sender.tag
    self.eventinfo = eventList[indexPath]
 
        performSegue(withIdentifier: "addRunnerSegue", sender: self)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
          //  if let event_id = self.eventList[indexPath.row].id {
                
//                ref?.child("Event").child(event_id).removeValue(completionBlock: { (error,ref) in
//                    if error != nil {
//                        print( "error \(String(describing: error))")
//                    }
//                    else
//                    { self.attemptReloadofTableView()
//                    }
//                    }
//                    )
   //        }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventRowSelected = true
        self.eventinfo = self.eventList[indexPath.row]
        
    }
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        EventTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
//        self.eventinfo = self.eventList[indexPath.row]
//        performSegue(withIdentifier: "addRunnerSegue", sender: self)
//    }
    
    
    
    func attemptReloadofTableView(){
       // eventList.removeAll
        // if meetonlineid != "" {
         //   eventList = DBAccessor.sharedInstance.getEvents(meetid: meetonlineid)}
        
        eventList = meetinfo?.events.sorted(byKeyPath: "name", ascending: true)
        
        EventTableView.reloadData()
//        let eventRef = ref.child("Event").queryOrdered(byChild: "meet").queryEqual(toValue: meetid)
//        
//        eventRef.observe(.value, with: { snapshot in
//            
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                if let eventDict = snap.value as? [String:AnyObject] {
//                    let eventid = snap.key
//                    let eventInfo = EventInfoModel(id: eventid, eventData: eventDict)
//                    self.eventlist.append(eventInfo)
//                }
//            }
//            self.EventTableView.reloadData()
//        /})
       // }
    }
    
    
    func saveMeettoRealm() -> Int{
        if (titleLabel.text?.isEmpty)! {
            titleLabel.layer.borderColor = UIColor.red.cgColor
            titleLabel.layer.borderWidth = 2.0
            return -1
        } else {
             titleLabel.layer.borderWidth = 0
        }
        if (locationLabel.text?.isEmpty)!{
            locationLabel.layer.borderColor = UIColor.red.cgColor
            locationLabel.layer.borderWidth = 2.0
            return -1
        } else {
            locationLabel.layer.borderWidth = 0
        }
        if (dateLabel.text?.isEmpty)!{
            dateLabel.layer.borderColor = UIColor.red.cgColor
            dateLabel.layer.borderWidth = 2.0
            return -1
        } else {
             dateLabel.layer.borderWidth = 0
        }
        if (zipCodeLabel.text?.isEmpty)!{
            zipCodeLabel.text = String(0)
        }
        
        let name = titleLabel.text
        let location = locationLabel.text
        let datetext = dateLabel.text
        let citytext = cityLabel.text
        let statetext = stateLabel.text
        let ziptext = zipCodeLabel.text
        
        let meetIdKey = (meetinfo?.idKey ?? "")
        if meetIdKey != "" {
            try! uiRealm.write {
                meetinfo?.name = name!
                meetinfo?.date = datetext!
                meetinfo?.address = location
                meetinfo?.city = citytext
                meetinfo?.state = statetext
                meetinfo?.zipcode.value = Int(ziptext!)
            }
            return 2
                navigationController?.popViewController(animated: true)
                
            } else {
                let newMeet = MeetDataModel(name: name!, date: datetext!, address: location!, city: citytext!, state: statetext!, zipcode: Int(ziptext!)!)
                newMeet.writeToRealm()
                meetonlineid = newMeet.idKey
                meetinfo = newMeet
                navigationController?.popViewController(animated: true)
            return 3
            }
    }
    
    @IBAction func saveMeetButtonPressed(_ sender: Any) {
        
        if saveMeettoRealm() > 0 {
            navigationController?.popViewController(animated: true)
        }
     
    }
    
    @IBAction func cancelMeetButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Date Picker

    
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
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  "HH:mm a"
//        let eventTime = eventinfo?.time ?? "12:00 a"
//        if let date = dateFormatter.date(from: (eventTime)) {
//            picker.date = date
//        }

        
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
     
    

    
    // MARK: - Navigation
  
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "addEventSegue" {
                if saveMeettoRealm() < 0 {
                    return false
                }
            }
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEventSegue" {
            // Get the new view controller using segue.destinationViewController.
            let DvC = segue.destination as! AddEventViewController
            // Pass the meet online id to the new view controller.
            DvC.currentMeet = meetinfo
            
        } else if segue.identifier == "editEventSegue" {
            let DvC = segue.destination as! AddEventViewController
            DvC.currentMeet = meetinfo
            if self.eventList.count > 0 {
                DvC.editmode = true
                if eventRowSelected {
                    selectedrow =  (EventTableView.indexPathForSelectedRow?.row)!
                    DvC.currentEvent = self.eventList[selectedrow]
                } else {
                    DvC.currentEvent = self.eventList[0]
                }
            }
        } else {
            let DvC = segue.destination as! AddMeetRunnerViewController
            DvC.eventData = self.eventinfo
        }
        
        EventTableView.reloadData()
        
        
    }
    
    
    
}


    


