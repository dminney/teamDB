//
//  RunnerListViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/29/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
class RunnerListCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var runnerFinishTimeLabel: UILabel!
    @IBOutlet weak var runnerSplit1Label: UILabel!
    @IBOutlet weak var runnerSplit2Label: UILabel!
}

class RunnerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var meetNameLabel: UILabel!
    @IBOutlet weak var meetDateLabel: UILabel!
    @IBOutlet weak var runnerTableView: UITableView!
    
    var appState : StateController!
    var runnerList = [ResultsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetNameLabel.text = appState.currentMeet?.name
        meetDateLabel.text = appState.currentMeet?.date
        runnerTableView.delegate = self
        runnerTableView.dataSource = self
        addRunnerIDs()
        runnerTableView.reloadData()
    }
 
    override func viewWillAppear(_ animated: Bool) {
       
        addRunnerIDs()
        runnerTableView.reloadData()
            
    }
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if runnerList.count > 0 {
        return runnerList.count
    } else {
        return 1
    }
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = runnerTableView.dequeueReusableCell(withIdentifier: "RunnerListCell") as! RunnerListCell
    if runnerList.count == 0 {
        cell.eventNameLabel.text = "No Runners Scheduled"
        cell.runnerFinishTimeLabel.text = ""
        cell.runnerSplit1Label.text = ""
        cell.runnerSplit2Label.text = ""
    } else {
        let runnerData = runnerList[indexPath.row]
        let firstname = runnerData.firstname
        let lastname = runnerData.lastname
        var timestring : String
        cell.eventNameLabel.text = " \(firstname) \(lastname)"
        let finaltime = TimeInterval(runnerData.finaltime!)
        timestring = stringFromTimeInterval(interval: finaltime) as String
        
        cell.runnerFinishTimeLabel.text = " \(timestring) "
        let mile1time = TimeInterval(runnerData.mile1time!)
        timestring = stringFromTimeInterval(interval: mile1time) as String
        cell.runnerSplit1Label.text = " \(timestring) "
        let mile2time = TimeInterval(runnerData.mile2time!)
        timestring = stringFromTimeInterval(interval: mile2time) as String
        cell.runnerSplit2Label.text = " \(timestring) "
    }
    
    return cell
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addRunnerIDs(){
        
        let meetonlineid  = appState.currentMeet?.onlineid
        if meetonlineid != "" {
            runnerList.removeAll()
            var resultlist = [ResultsModel]()
            resultlist  = DBAccessor.sharedInstance.getMeetRunners(meetid: meetonlineid!)
            var i : Int = 0
            while i < resultlist.count{
                let newRunnerid = resultlist[i].runnerid
                let runnerfound = DBAccessor.sharedInstance.getRunnerInfo(runnerid: newRunnerid)
                resultlist[i].firstname = runnerfound.firstname
                resultlist[i].lastname = runnerfound.lastname
                runnerList.append(resultlist[i])
                i += 1
            }
        }
    }
    
}
