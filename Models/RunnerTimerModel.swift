//
//  RunnerModel.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 11/22/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation

class RunnerTimerModel {

    var id: String?
    var firstname : String = ""
    var lastname : String = ""
    var mile1time : String = "00:00:00"
    var mile2time : String = "00:00:00"
    var totaltime : String = "00:00:00"
    var mile1   : Bool = false
    var mile2   : Bool = false
    var total   : Bool = false
    
    var runner : String!
    var competing : Bool = false
    var grade: String!
    
    var exists : Bool = false
    
    var exists_id : String = ""
    
    init () {
        
    }

    init(id: String?, runnerData: Dictionary<String, AnyObject>) {
        
        self.id = id
        
        if let firstname = runnerData["firstname"] as? String {
            self.firstname = firstname        }
        
        if let lastname = runnerData["lastname"] as? String {
            self.lastname = lastname        }
        
        if let mile1time = runnerData["mile1"] as? String {
            self.mile1time = mile1time        }
        
        if let mile2time = runnerData["mile2"] as? String {
            self.mile2time = mile2time        }
        
        if let finaltime = runnerData["final"] as? String {
            self.totaltime = finaltime       }
        
        if let runnerid = runnerData["runnerid"] as? String {
            self.runner = runnerid       }
       
        
    }
}

