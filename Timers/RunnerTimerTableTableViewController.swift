//
//  RunnerTimerTableTableViewController.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 11/21/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

func stringFromTimeInterval(interval: TimeInterval) -> NSString {
    
    let ti = NSInteger(interval)
    
    let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 100)
    
    let seconds = ti % 60
    let minutes = (ti / 60)
    
    
    return NSString(format: "%0.2d:%0.2d.%.2d",minutes,seconds,ms)
}

class RunnerTimerTableTableViewController: UITableViewController {
    
    var runnerlist = [ResultsModel]()
    
    var timeString : String = "00:00:00"
    var timeinterval : Double!
    
    @IBOutlet var runnerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runnerTableView.delegate = self
        runnerTableView.dataSource  = self
        self.runnerTableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows which is the number of runners in the event
        return runnerlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = runnerTableView.dequeueReusableCell(withIdentifier: "RunnerCell") as!StopWatchCellTableViewCell
        let runnerdata = runnerlist[indexPath.row]
        let firstname = runnerdata.firstname
        let lastname = runnerdata.lastname
        var timestring : String
           // Configure the cell...
        cell.delegate = self
        cell.runnerNameLabel.text = " \(firstname) \(lastname)"
        // check to see if any time has been recorded yet
        if (runnerdata.total){
            // if the runner is finished hide the split button and display the total time
            cell.splitButton.isHidden = true
            let finaltime = TimeInterval(runnerdata.finaltime!)
                timestring = stringFromTimeInterval(interval: finaltime) as String
          
            cell.timerlabel.text = " \(timestring) "
        } else
            // display the timer time
        {cell.timerlabel.text = " \(timeString) "}
        if (runnerdata.mile1) {
            // if finished with the first mile change the text and color of the split button
            cell.splitButton.backgroundColor = .green
            cell.splitButton.setTitle("Mile 2", for: .normal)
            cell.splitButton.titleLabel?.textColor = .black
        } else {
             // if not finished with the first mile change the text and color of the split button to display 1 mile
            cell.splitButton.backgroundColor = .yellow
            cell.splitButton.setTitle("Mile 1", for: .normal)
            cell.splitButton.titleLabel?.textColor = .black
        }
        // display the 1 mile time either recorded time or 1mi:00:00:00
        let mile1time = TimeInterval(runnerdata.mile1time!)
         timestring = stringFromTimeInterval(interval: mile1time) as String
        cell.mile1label.text = " 1 mi: \(timestring)"
        if (runnerdata.mile2) {
              // if finished with the second mile change the text and color of the split button
            cell.splitButton.backgroundColor = .blue
            cell.splitButton.setTitleColor(.white, for: .normal)
            cell.splitButton.setTitle("Final", for: .normal)
            
        }
        //Display the 2 mile time, either the recorded time or 2 mi:00:00:00
        let mile2time = TimeInterval(runnerdata.mile2time!)
         timestring = stringFromTimeInterval(interval: mile2time) as String
        cell.mile2label.text = " 2 mi: \(timestring)"
        
        
        return cell
    }
    
    

    
    func resetRunners(){
        // function to reset the all of the runner times when starting or restarting an event
        // also reset the variables for mile1, mile2 and total completed
        var count = 0
        let total = runnerlist.count as Int
        while count < total {
            let runnerdata = runnerlist[count]
            runnerdata.finaltime = 0
            runnerdata.mile1time = 0
            runnerdata.mile2time = 0
            runnerdata.mile1 = false
            runnerdata.mile2 = false
            runnerdata.total = false
            count += 1
        }
    }
  

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


extension RunnerTimerTableTableViewController : StopwatchDelegate {
    
    func didTapStopButton(cell: StopWatchCellTableViewCell) {
        // Check to see that timer has been started
      //  if self.parentViewController.startStopWatch == true {
        // get which row index we are at
        let indexPath = self.tableView.indexPathForRow(at: cell.center)!
   
        // check if mile 1 has been recorded if not record mile 1 time
        if (runnerlist[indexPath.row].mile1) && (runnerlist[indexPath.row].mile2 == false) {
            runnerlist[indexPath.row].mile1time = 0
            runnerlist[indexPath.row].mile1 = false
             
        }
            // check if mile 2 has been recorded if not record mile 2 time and mark as being recorded
        else if (runnerlist[indexPath.row].mile2) && (runnerlist[indexPath.row].total == false){
            runnerlist[indexPath.row].mile2time = 0
            runnerlist[indexPath.row].mile2 = false}
        
            // check if final time has been recorded if not record final time and mark as being recorded
        else if (runnerlist[indexPath.row].total)
        {runnerlist[indexPath.row].finaltime = 0
            runnerlist[indexPath.row].total = false
             cell.splitButton.isHidden = false
       }
        
    }
    
    func didTapResetButton(cell: StopWatchCellTableViewCell) {
        // Check to see that timer has been started
   //     if super.startStopWatch == true {
        // get which row index we are at
   
        let indexPath = self.tableView.indexPathForRow(at: cell.center)!
        // check if mile 1 has been recorded if not record mile 1 time
        if (runnerlist[indexPath.row].mile1 == false) {
        runnerlist[indexPath.row].mile1time = timeinterval
            runnerlist[indexPath.row].mile1 = true}
        
            // check if mile 2 has been recorded if not record mile 2 time and mark as being recorded
        else if (runnerlist[indexPath.row].mile2 == false) {
            runnerlist[indexPath.row].mile2time = timeinterval
            runnerlist[indexPath.row].mile2 = true}
        
            // check if final time has been recorded if not record final time and mark as being recorded
        else {runnerlist[indexPath.row].finaltime = timeinterval
            runnerlist[indexPath.row].total = true
        }
        let runnerupdate = runnerlist[indexPath.row]
        let id = DBAccessor.sharedInstance.updateResult(resultid: runnerupdate.id!, newResult: runnerupdate)
        if id == false {
            print("result update Error")
        }
     //   }
    }
    
    func updateDatabase(){
//    let meet : Dictionary = ["name":name!, "location":location!,"date":datetext!] as [String : AnyObject]
//    
//    if delegate != nil {
//    if meetid != "" {
//    ref?.child("Meet").child(meetid).setValue(meet)
//    delegate?.userDidEnterData(data: meet, id:meetid, row:lastrow)
//    }
//    else {
//    ref?.child("Meet").childByAutoId().setValue(meet)
//    
    }
}

