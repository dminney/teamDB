//
//  CustomAddRunnerCellModel.swift
//  teamDB
//
//  Created by Dave Minney on 12/30/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import Foundation
import UIKit

class AddRunnerCellModel {
    var runner : String!
    var competing : Bool = false
    var grade: String!
    
    var id: Int64?
    var firstname : String = ""
    var lastname : String = ""
    var exists : Bool = false
    var results_id : Int64?
    var online_id : String = ""
    
    init (id: Int64) {
        self.id = id
        firstname = ""
        lastname = ""
        exists = false
        online_id = ""
        competing = false
        results_id = 0
    }
    
//    init(id: String?, runnerData: Dictionary<String, AnyObject>) {
//
//        self.id = id
//
//        if let firstname = runnerData["firstname"] as? String {
//            self.firstname = firstname        }
//
//        if let lastname = runnerData["lastname"] as? String {
//            self.lastname = lastname        }
//
//
//        if let grade = runnerData["grade"] as? String {
//            self.grade = grade        }
//
//
//    }
}
