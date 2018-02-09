//
//  MeetTableViewController.swift
//  teamDB
//
//  Created by Dave Minney on 10/30/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MeetCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
 
    @IBOutlet weak var dateLabel: UILabel!
    
}


class MeetTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var tabBar : CustomTabbarController?
    var appState : StateController!
    var selectedrow : Int = 0
    var meetList = [MeetModel]()
    var ref: DatabaseReference!
    var db: OpaquePointer?
    
     @IBOutlet var meetTableView: UITableView!
    
    
//    func userDidEnterData(data: Dictionary<String, AnyObject>, id: String, row: Int) {
//        let meetInfo = MeetModel(id: 0, name: data["name"] as! String, date: data["date"] as! String, address: data["location"] as! String)
//        meetList[row] = meetInfo
//    }
//    
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meetTableView.dequeueReusableCell(withIdentifier: "MeetTableCell") as! MeetCell
        let meetData = meetList[indexPath.row]
        let meetName = meetData.name
        let meetDate = meetData.date
        cell.nameLabel?.text = meetName
        cell.dateLabel?.text = meetDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditMeetView", sender: self)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
    
    override func viewWillAppear(_ animated: Bool) {
    //    meetList.removeAll()
        meetList = DBAccessor.sharedInstance.getMeets()
        meetTableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetTableView.delegate = self
        meetTableView.dataSource = self
        // Still need to pass which meet, event, and runner is selected between controllers using AppState
        appState = (tabBarController as! CustomTabbarController).appState!
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }


    

    /*
    // MARK: - Navigation

 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMeetSegue"
        {
    //        let sendingVC: AddMeetViewController = segue.destination as! AddMeetViewController
            
//            sendingVC.delegate = self as! DataSentDelegate
        }
        else if segue.identifier == "EditMeetView"
        {
            let DvC = segue.destination as! AddMeetViewController
            selectedrow = (self.meetTableView.indexPathForSelectedRow?.row)!
        
            appState.currentMeet = meetList[selectedrow]
            DvC.meetinfo = meetList[selectedrow]
            
            DvC.meetid = meetList[selectedrow].id
            DvC.selectedrow = selectedrow
         //   DvC.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
