//
//  AppState.swift
//  teamDB
//
//  Created by Dave Minney on 12/26/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class StateController {
    
    var event : String = ""
    var meet : String = ""
    var runnerlist = [RunnerTimerModel]()
    var meetlist = [MeetModel]()
    var eventlist = [EventInfoModel]()
    var ref: DatabaseReference!
    var eventListCreated : Bool = false
    var meetid : String = ""
    var eventid : String = ""
    var currentevent : EventInfoModel?
    var currentMeet : MeetModel?
    var currentUser : appUserModel?
    var currentTeam : String?
    var currentTeamName : String?
    func createMeetList(){
        
              ref = Database.database().reference()
        meetlist.removeAll()
//        ref?.child("Meet").observe(.childAdded, with: {(snapshot) in
//            let id = snapshot.key as String
//            if let meetshownDictionary  = snapshot.value as?[String:AnyObject]{
////                let meetInfo = MeetModel(id: id, meetData: meetshownDictionary)
////                self.meetlist.append(meetInfo)
//            }
//        })
    }
    
    
    func createEventList(meetid : String) {
       
        eventlist.removeAll()
        
//        let eventRef = ref.child("Event").queryOrdered(byChild: "meet").queryEqual(toValue: meetid)
//
//        eventRef.observe(.value, with: { snapshot in
//
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                let key = snap.key as String
//                if let eventDict = snap.value as? [String:AnyObject] {
//                    let eventInfo = EventInfoModel(id: key, eventData: eventDict)
//                    self.eventlist.append(eventInfo)
//
//                }
//            }
//
//        })
    }

    func addMeet(meetid : String, meetinfo : Dictionary<String, AnyObject>){
        if meetid != "" {
            ref?.child("Meet").child(meetid).setValue(meetinfo)
        }
        else {
            ref?.child("Meet").childByAutoId().setValue(meetinfo)
            
        }
    }
    
    init(meet : String, event : String) {
        self.event = event
        self.meet = meet
  
    }
    
    init() {
        self.currentUser?.role = 1
        
    }
    
    func updateCurrentEvent(eventdata : EventInfoModel) {
        currentevent = eventdata
        self.event = (currentevent?.name)!
        
    }
    
    func updateCurrentMeet(meetData : MeetModel){
        currentMeet = meetData
        self.meet = (currentMeet?.name)!
    }

}
