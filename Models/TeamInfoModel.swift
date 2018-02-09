//
//  TeamInfoModel.swift
//  teamDB
//
//  Created by Dave Minney on 1/19/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import Foundation

class TeamInfoModel {
    
    var organization : String
    var mascot : String
    var city : String
    var state : String
    var zipcode : Int
    var id : String?
    
    init (){
        organization = ""
        mascot = ""
        city = ""
        state = ""
        zipcode = 0
    }
    
    init (name: String, postcode: Int){
        organization = name
        mascot = ""
        city = ""
        state = ""
        zipcode = postcode
    }

    init (id: String, teamData: Dictionary<String, AnyObject>) {
        self.id = id
        if let _organization = teamData["organization"] as? String {
            self.organization = _organization       } else {
            self.organization = ""
        }
        if let _mascot = teamData["mascot"] as? String {
            self.mascot = _mascot       } else {
            self.mascot = ""
        }
        if let _city = teamData["city"] as? String {
            self.city = _city       } else {
            self.city = ""
        }
        if let _state = teamData["state"] as? String {
            self.state = _state       } else {
            self.state = ""
        }
        if let _zipcode = teamData["zipcode"] as? String {
            self.zipcode = Int(_zipcode)!      } else {
            self.zipcode = 0
        }
        }
}
