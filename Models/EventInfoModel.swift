//
//  MeetEventModel.swift
//  teamDB
//
//  Created by Dave Minney on 11/3/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation
class EventInfoModel {
    
    let id: Int64?
    var name : String = ""
    var gender :Int
    var time : String!
    var team : String!
    var grade : String!
    var meet : String!
    var onlineid : String!
    var updated_at : String!
    
    init (id:Int64){
        self.id = id
        name = ""
        meet = ""
        time = ""
        team = ""
        gender = 0
        grade = ""
        onlineid = ""
        
    }
    
    init (id: Int64 ,name: String,onlineid: String, meetid: String, time: String, team: String, gender: Int, grade: String, updated_at: String){

        self.id = id
        self.name = name
        self.onlineid = onlineid
        self.meet = meetid
        self.time = time
        self.team = team
        self.gender = gender
        self.grade = grade
        self.updated_at = updated_at
        
    }
   
}
