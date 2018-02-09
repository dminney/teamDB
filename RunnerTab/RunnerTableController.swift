//
//  ViewController.swift
//  teamDB
//
//  Created by Dave Minney on 10/9/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import os.log

class RunnerCell : UITableViewCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}


class RunnerTableController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var runnerList = [RunnerInfoModel]()
    var ref: DatabaseReference!
    var runnerEntered : [DataSnapshot] = []
    var runnerinfo = RunnerInfoModel(id:0)
    var rowselected : Bool = false
    @IBOutlet weak var tableView: UITableView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        runnerList = DBAccessor.sharedInstance.getAllRunners()
        self.tableView.reloadData()
        
        
//        ref?.child("Runner").observe(.childAdded, with: {(snapshot) in
//            let id = snapshot.key as String
//            self.runnerEntered.append(snapshot)
//            if let runnershownDictionary  = snapshot.value as?[String:AnyObject]{
//                let runnerInfo = RunnerInfoModel(id: id, runnerData: runnershownDictionary)
//                self.runnerlist.append(runnerInfo)
//            }
 //           self.tableView.reloadData()
 //         })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rowselected = false
        runnerList = DBAccessor.sharedInstance.getAllRunners()
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Test
        
    }

//  Mark - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runnerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunnerCell") as! RunnerCell
        let runnerData = runnerList[indexPath.row]
        let firstName = runnerData.firstname
        let lastName = runnerData.lastname
        cell.nameLabel?.text = "\(firstName) \(lastName)"
        cell.timeLabel?.text = "xx.xx.xx"
        let runnerButton = UIButton(type: .custom) as UIButton
            runnerButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            runnerButton.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
            runnerButton.setImage(#imageLiteral(resourceName: "cc-runner"), for: .normal)
            runnerButton.tag = indexPath.row
        cell.accessoryView = runnerButton as UIView
        return cell
    }
    
    @objc func accessoryButtonTapped(sender:UIButton){
        let indexPath = sender.tag
         self.runnerinfo = self.runnerList[indexPath]
        performSegue(withIdentifier: "EditRunnerSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        runnerinfo = self.runnerList[indexPath.row]
        rowselected = true
    }
    
//
//        let alertController = UIAlertController(title: nameLabel, message: "Update Runner Information" , preferredStyle: .alert)
//        //the confirm action taking the inputs
//        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
//            let id = runnerselected.id
//            let firstName = alertController.textFields?[0].text
//            let lastName = alertController.textFields?[1].text
//            let email = alertController.textFields?[2].text
//            let phone = alertController.textFields?[3].text
//
//
//            let runner : Dictionary = ["firstname":firstName!, "lastname":lastName!,"email":email ?? "nothing.gmail.com","phone":phone!, "gender":true, "grade" : "8"] as [String : Any]
//            self.updateRunner(id: id!, runner: runner)
//        }
//        //the cancel action doing nothing
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//
//        //adding two textfields to alert
//        alertController.addTextField { (textField) in
//            textField.text = runnerselected.firstname
//        }
//        alertController.addTextField { (textField) in
//            textField.text = runnerselected.lastname
//        }
//
//        alertController.addTextField { (textField) in
//            textField.text = runnerselected.email
//        }
//
//        alertController.addTextField { (textField) in
//            textField.text = runnerselected.phone
//        }
//        //adding action
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//
//        //presenting dialog
//        present(alertController, animated: true, completion: nil)
//
 //  }
    
    func updateRunner(id:String, runner:Dictionary<String, Any>){
        //updating the artist using the key of the artist
        ref?.child("Runner").child(id).setValue(runner)
    }
    
    
     // MARK: - Navigation
     

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddNewRunnerSegue" {
        // Get the new view controller using segue.destinationViewController.
        
        guard let DvC = segue.destination as? AddRunnerViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        DvC.editmode = false
        DvC.currentRunner = RunnerInfoModel(id: 0)
    } else if segue.identifier == "EditRunnerSegue" {
        guard let DvC = segue.destination as? AddRunnerViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        if self.runnerList.count > 0 {
            DvC.editmode = true
            if rowselected {
                let selectedrow =  (tableView.indexPathForSelectedRow?.row)!
                DvC.currentRunner = self.runnerList[selectedrow]
            } else {
                DvC.currentRunner = self.runnerList[0]
            }
        }
    }
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//        
       super.prepare(for: segue, sender: sender)
//        
//        
//        switch(segue.identifier ?? "") {
//            
//            
//        case "AddItem":
//            os_log("Adding a new runner.", log: OSLog.default, type: .debug)
//            
//
//            
//        case "ShowDetail":
//            guard let AddPlayerViewController = segue.destination as? ViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            indexPath = self.tableView indexPathForSelectedRow
//            
//            
//            //            guard let selectedRunnerCell = sender as? tableView.indexPath else {
////                fatalError("Unexpected sender: \(sender)")
////            }
////
////            guard let indexPath = tableView.indexPath(for: selectedRunnerCell) else {
////                fatalError("The selected cell is not being displayed by the table")
////            }
////
////            let selectedRunner = runnerEntered[indexPath.row]
//            AddPlayerViewController.
////
//
// //       }
//        
//
//        default: break
//            
//        }
  }
}

