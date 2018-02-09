//
//  RunnerData.swift
//  teamDB
//
//  Created by Dave Minney on 10/17/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation


class RunnerInfoModel {

    let id: Int64?
    var firstname : String = ""
    var lastname : String = ""
    var onlineid : String = ""
    var gender :Int!
    var grade : String!
    var birthdate : String!
    var email : String!
    var phone : String!
    var address : String!
    var city : String!
    var state : String!
    var zipcode : String!
    var bdate : String!
    var active : Bool!
    var updated_at: String!
    
    private var _lifetimePR : String!   // Strings or save as the number of milliseconds??
    private var _seasonPR : String! // Strings or save as the number of milliseconds??
 
    
    init (id:Int64){
        self.id = id
        firstname = ""
        lastname = ""
        onlineid = ""
        gender = 0
        bdate = ""
        grade = ""
        email = ""
        phone = ""
        address = ""
        city = ""
        state = ""
        zipcode = ""
        active = false
    }
    
    init(id: Int64 ,firstname : String, lastname : String, onlineid : String, gender : Int, gradelevel : String, birthdate: String, email : String, phone : String, address : String, city: String, state: String, zipcode: String, activerunner: Bool, updated_at: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.onlineid = onlineid
        self.gender = gender
        self.grade = gradelevel
        self.bdate = birthdate
        self.email = email
        self.phone = phone
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.active = activerunner
        self.updated_at = updated_at
        
    }
 

//
    init(id: Int64?, runnerData: Dictionary<String, AnyObject>) {
        
        self.id = id
        
        if let firstname = runnerData["firstname"] as? String {
            self.firstname = firstname        }
        
        if let lastname = runnerData["lastname"] as? String {
            self.lastname = lastname        }
        
        if let gender = runnerData["gender"] as? Int {
            self.gender = gender        }
        
        if let gradelevel = runnerData["grade"] as? String {
            self.grade = gradelevel        }
        
        if let email = runnerData["email"] as? String {
            self.email = email        }
        
        if let phone = runnerData["phone"] as? String {
            self.phone = phone        }
        
        if let address = runnerData["address"] as? String {
            self.address = address        }
        
        if let city = runnerData["city"] as? String {
            self.city = city        }
        
        if let state = runnerData["state"] as? String {
            self.state = state        }
        
        if let zipcode = runnerData["zipcode"] as? String {
            self.zipcode = zipcode        }
        
        if let birthdate = runnerData["birthdate"] as? String {
            self.birthdate = birthdate }
        
        if let active = runnerData["active"] as? Bool {
            self.active = active       }
        
    }
}

//class FIRDataObject: NSObject {
//
//    let snapshot: DataSnapshot
//    var key: String { return snapshot.key }
//    var ref: DatabaseReference { return snapshot.ref }
//
//    required init(snapshot: DataSnapshot) {
//
//        self.snapshot = snapshot
//
//        super.init()
//
//        for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
//            if responds(to: Selector(child.key)) {
//                setValue(child.value, forKey: child.key)
//            }
//        }
//    }
//}

