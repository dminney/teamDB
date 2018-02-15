//
//  AddMeetRunnerViewController.swift
//  teamDB
//
//  Created by Dave Minney on 11/8/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift

class AddMeetRunnerViewController: UITableViewController {
    var ref: DatabaseReference!
    var eventData : EventDataModel?
    var runnershown = AddRunnerCellModel(id:0)
    var runnerid = " "
   
    var eventRunnerlist = [AddRunnerCellModel]()
    
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet var runnerTableView: UITableView!
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        var i : Int = 0
//        while i < eventRunnerlist.count {
//            if eventRunnerlist[i].competing {
//                let meetid =  eventData.meet
//                let eventid = eventData.onlineid
//                let competitor = ResultsModel(id: Int64(i), eventid: eventid!, runnerid: eventRunnerlist[i].online_id, mile1time: 0, mile2time: 0, finaltime: 0, meetid: meetid!)
//                let runnerupdate : Dictionary = ["runnerid":eventRunnerlist[i].online_id, "meet":meetid,"event":eventid, "mile1":"00:00:00", "mile2": "00:00:00", "final":"00:00:00"] as [String : AnyObject]
//
//                let resultRef = ref?.child("Result").childByAutoId()
//                resultRef?.setValue(runnerupdate)
//                // To do:
//                // Do we need the id of the result ?????
//                // let resultid = resultRef?.key
//
//                if eventRunnerlist[i].exists {
//                    let id = DBAccessor.sharedInstance.updateResult(resultid: eventRunnerlist[i].id!, newResult: competitor)
//                } else {
//                    if let id = DBAccessor.sharedInstance.addResult(resultEventID: eventid!, resultRunnerID: eventRunnerlist[i].online_id, resultMile1Time: 0, resultMile2Time: 0, resultFinalTime: 0, resultmeetid: meetid!){
//                    }
//                }
//
//            } else {
//                if eventRunnerlist[i].exists { let id = DBAccessor.sharedInstance.deleteResult(resultid: eventRunnerlist[i].results_id!) }
//            }
//            i += 1
//        }
      navigationController?.popViewController(animated: true)
    }
    

    func fillDataModel() {
        
        var runnerlist : Results<RunnerDataModel>!
//        var resultlist = [ResultsModel]()
        var resultPredicate : NSPredicate
        let gendersort = Int((eventData?.gender)!)
        let gradesort = eventData?.grade
        let predicateString = "gender == \(gendersort)"
    
             resultPredicate = NSPredicate(format: predicateString)
       
        
        
//        let predicate = NSPredicate(format:"gender == %@ AND grade == %@", gendersort!, gradesort!)
        runnerlist = uiRealm.objects(RunnerDataModel.self).filter(resultPredicate)
 //       runnerlist = DBAccessor.sharedInstance.getAvailableRunners(gender: eventData.gender, grade: eventData.grade)
  //      resultlist = DBAccessor.sharedInstance.getEventRunners(eventid: eventData.onlineid)
        
//         let eventid = eventData.id
//            let resultRef = ref.child("Result").queryOrdered(byChild: "event").queryEqual(toValue: eventid)
//              resultRef.observe(.value, with: { snapshot in
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                if let eventDict = snap.value as? [String:AnyObject] {
//                    let key = snap.key as String
//                    let runnerid = eventDict["runnerid"] as? String
                   var i : Int64 = 0
       // var j : Int = 0
            while i < runnerlist.count{
                let x = Int(truncatingIfNeeded: i)
                        let eventRunner = AddRunnerCellModel(id:i)
                  //      eventRunner.online_id = runnerlist[x].onlineid
                        eventRunner.firstname = runnerlist[x].firstname
                        eventRunner.lastname = runnerlist[x].lastname
//                    j = 0
//                       while j < resultlist.count {
//                        if resultlist[j].runnerid == runnerlist[x].onlineid {
//                            eventRunner.competing = true
//                            eventRunner.exists = true
//                            eventRunner.results_id = resultlist[j].id
//                        }
//                        j += 1
//                        }
                        eventRunnerlist.append(eventRunner)
                        i += 1
                        }

                self.runnerTableView.reloadData()
                
           //   })
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runnerTableView.delegate = self
        runnerTableView.dataSource = self
          fillDataModel()
       eventTitleLabel.text = eventData?.name
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventRunnerlist.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddRunnerCell", for: indexPath) as! AddRunnerCell
         cell.delegate = self
        let runnerData = self.eventRunnerlist[indexPath.row]

    // Configure the cell...

        cell.setupwithModel(model: runnerData)
        cell.runnerSwitch.tag = indexPath.row
       
        return cell
    }
  


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
}



extension AddMeetRunnerViewController : AddRunnerCellDelegate {
    func didTapSwitch(cell: AddRunnerCell) {
       let indexPath = self.tableView.indexPathForRow(at: cell.center)!
        eventRunnerlist[indexPath.row].competing = cell.runnerSwitch.isOn
        if eventRunnerlist[indexPath.row].exists {
            if eventRunnerlist[indexPath.row].competing == false {
                 ref = Database.database().reference()
                 let runner_id = self.eventRunnerlist[indexPath.row].online_id
                ref?.child("Result").child(runner_id).removeValue(completionBlock: { (error,ref) in
                    if error != nil {
                        print( "error \(String(describing: error))")
                    }
                }
                )
            }
        }
        }
}
