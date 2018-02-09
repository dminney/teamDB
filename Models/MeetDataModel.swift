//
//  MeetDataModel.swift
//  teamDB
//
//  Created by Dave Minney on 10/30/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation

class MeetModel {

    let id: Int64?
    
    var name : String
    var date : String
    var address : String
    var city : String!
    var state : String!
    var zipcode : Int!
    var onlineid : String
    var updated_at : String!
    
    init (id:Int64){
        self.id = id
        name = ""
        date = ""
        address = ""
        city = ""
        state = ""
        zipcode = 0
        onlineid = ""
    }
    //    init (id: Int64 ,name : String, date : String, address: String, city: String, state: String, zipcode: Int){

    init (id: Int64 ,name: String, onlineid: String, date: String, address: String, city: String, state: String, zipcode: Int, updated_at: String){
        self.id = id
        self.name = name
        self.date = date
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.onlineid = onlineid
        self.updated_at = updated_at
    }
}
