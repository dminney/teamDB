//
//  ViewController.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 11/21/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}


class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    var tabBar : CustomTabbarController?
    
    var startTime = Date()
    var timeElapsed = Double()
    var elapsedTimeFraction = NSString()
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    var nameString: [String] = []
    var lastString: String = ""
    
    var stopwatchString : String = ""
    
    var startStopWatch : Bool = true
    
    var stopwatch : StopWatchModel!

    let meetpicker = UIPickerView()
    let eventpicker = UIPickerView()
    
    
    @IBOutlet weak var timerlabel: UILabel!
    var addLap : Bool = false
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var meetText: UITextField!
    @IBOutlet weak var eventText: UITextField!
    
    
    var meetlist = [MeetModel]()
    var ref: DatabaseReference!
    var meetid : String = ""
    var timereventlist = [EventInfoModel]()
    var eventgender : Int = 0
    
    var meetrow : Int = 0
    var eventid: Int64?
    var event_online_id : String!
    
    var runnerlist = [ResultsModel]()
    var appstate : StateController!
    
    override func viewWillAppear(_ animated: Bool) {
 
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopwatch  = StopWatchModel()
        // Do any additional setup after loading the view, typically from a nib.
        
        meetpicker.delegate = self
        meetpicker.dataSource = self
        eventpicker.delegate = self
        eventpicker.dataSource = self

        ref = Database.database().reference()
        
        meetlist.removeAll()
        appstate = (tabBarController as! CustomTabbarController).appState!
        meetlist = DBAccessor.sharedInstance.getMeets()
        
      //  meetText.text = appstate.currentMeet?.name
        
//        if (appstate.currentevent?.name != "") {
//            eventText.text = appstate.currentevent?.name}
        createMeetPicker()
        createEventPicker()
    }

    @IBAction func startTimerPressed(_ sender: Any) {
        
        if stopwatch.timing == false {
            resetButton.isHidden = false
            
            stopwatch.starttimer()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(FirstViewController.processTimer), userInfo: nil, repeats: true)
        startButton.setTitle("Stop All", for: .normal)
            
        } else {
            timer.invalidate()
            stopwatch.stoptimer()
          startButton.setTitle("Start All", for: .normal)
           
                  }
    }
    
    @objc func processTimer(){
        

        timerlabel.text = self.stopwatch.elapsedTimeasString()
        let childView = self.childViewControllers.last as! RunnerTimerTableTableViewController
        childView.timeString = stopwatch.elapsedTimeasString()
        childView.timeinterval = stopwatch.elapsedTime()
        childView.runnerTableView.reloadData()
        
        
        
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        stopwatch.stoptimer()
        startButton.setTitle("Start All", for: .normal)
        timer.invalidate()
        timerlabel.text = "00:00:00"
        resetButton.isHidden = true
        let childView = self.childViewControllers.last as! RunnerTimerTableTableViewController
        childView.timeString = "00:00:00"
        childView.resetRunners()
        childView.runnerTableView.reloadData()
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
            count = timereventlist.count}
        return count
    }
    
    // populate Picker View with Row String
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowString = ""
        if pickerView == meetpicker{
            rowString = meetlist[row].name
        }
        else if pickerView == eventpicker {
            rowString = timereventlist[row].name}
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
        meetid = meetlist[row].onlineid
 //       appstate.meetid = meetid
//        appstate.createEventList(meetid: meetid)
       self.view.endEditing(true)
        meetText.text = meetlist[row].name
        appstate.meet =  meetlist[row].name
        DispatchQueue.main.async(){
            self.timereventlist = DBAccessor.sharedInstance.getEvents(meetid: self.meetid)
            self.eventpicker.reloadAllComponents()
            let row = self.eventpicker.selectedRow(inComponent:0)
            if !self.timereventlist.isEmpty{
                self.eventText.text = self.timereventlist[row].name}
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
        if !timereventlist.isEmpty{
            eventText.text = timereventlist[row].name
            appstate.updateCurrentEvent(eventdata:timereventlist[row])
            self.eventgender = timereventlist[row].gender
            self.eventid = timereventlist[row].id!
            self.event_online_id  = timereventlist[row].onlineid
         
        }
        self.view.endEditing(true)
        self.runnerlist.removeAll()
        self.createRunnerList()
        
    }
    
    // Create EventList by querying based on Meet selected
    
//    func createEventList(){
//
//        let eventRef = ref.child("Event").queryOrdered(byChild: "meet").queryEqual(toValue: meetid)
//        eventlist.removeAll()
//        eventRef.observe(.value, with: { snapshot in
//
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                let key = snap.key as String
//                if let eventDict = snap.value as? [String:AnyObject] {
//                    let eventInfo = MeetEventModel(id: key, eventData: eventDict)
//                    self.eventlist.append(eventInfo)
//
//
//
//                }
//            }
//
//        })
//    }


    // Create RunnerList by querying based on event id of event selected
    
    func createRunnerList(){
       
            addRunnerIDs()
        
            self.stopwatch.stoptimer()
            self.startButton.setTitle("Start All", for: .normal)
            self.timer.invalidate()
            self.timerlabel.text = "00:00:00"
            self.resetButton.isHidden = true
            let childView = self.childViewControllers.last as! RunnerTimerTableTableViewController
            childView.timeString = "00:00:00"
            childView.runnerlist = self.runnerlist
            //childView.resetRunners()
            childView.runnerTableView.reloadData()
        }
    
    func addRunnerIDs(){

//        let runnerRef = ref.child("Result").queryOrdered(byChild: "event").queryEqual(toValue: self.eventid)
        self.runnerlist.removeAll()
        var resultlist = [ResultsModel]()
        resultlist  = DBAccessor.sharedInstance.getEventRunners(eventid : event_online_id  )
        var i : Int = 0
        while i < resultlist.count{
        let newRunnerid = resultlist[i].runnerid
          let runnerfound = DBAccessor.sharedInstance.getRunnerInfo(runnerid: newRunnerid)
            resultlist[i].firstname = runnerfound.firstname
            resultlist[i].lastname = runnerfound.lastname
            runnerlist.append(resultlist[i])
        i += 1
        }
//        let runnerRef = ref.child("Result").queryOrdered(byChild: "event")
//        //.queryEqual(toValue: eventgender)
//
//        runnerRef.observe(.value, with: { snapshot in
//            print(snapshot)
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                let id = snap.key as String
//                if let runnerDict = snap.value as? [String:AnyObject] {
//                    let runnerInfo = RunnerTimerModel(id:id , runnerData: runnerDict)
//                    self.runnerlist.append(runnerInfo)
//                    }
//
//                }
//            })
        }


}
    



    


