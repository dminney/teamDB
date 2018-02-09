//
//  ResultsModel.swift
//  teamDB
//
//  Created by Dave Minney on 1/7/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import Foundation

class ResultsModel {
    
    let id: Int64?
    var eventid: String = ""
    var runnerid: String = ""
    var mile1time : Double?
    var mile2time : Double?
    var finaltime : Double?
    var meetid: String = ""
 
    var firstname : String = ""
    var lastname : String = ""
   
    var mile1   : Bool = false
    var mile2   : Bool = false
    var total   : Bool = false
    
    var runner : String!
    var competing : Bool = false
    var grade: String!
    
    var exists : Bool = false
    
    var exists_id : String = ""
    
    
    init (id:Int64){
        self.id = id
        eventid = ""
        runnerid = ""
        mile1time = 0
        mile2time = 0
        finaltime = 0
        meetid = ""
        
    }
    
    init (id: Int64 ,eventid: String, runnerid: String, mile1time: Double, mile2time: Double, finaltime: Double, meetid: String){
        
        self.id = id
        self.eventid = eventid
        self.runnerid = runnerid
        self.mile1time = mile1time
        self.mile2time = mile2time
        self.finaltime = finaltime
        self.meetid = meetid
        
    }
    
}
