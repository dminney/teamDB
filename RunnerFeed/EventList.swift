//
//  EventList.swift
//  teamDB
//
//  Created by Dave Minney on 1/28/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit


class EventListCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventTeamLabel: UILabel!
    
}

class EventList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var meetNameLabel: UILabel!
    @IBOutlet weak var meetDateLabel: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    var appState : StateController!
    var eventList = [EventInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetNameLabel.text = appState.currentMeet?.name
        meetDateLabel.text = appState.currentMeet?.date
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventList.removeAll()
        
        let meetonlineid  = appState.currentMeet?.onlineid
        if meetonlineid != "" {
            eventList = DBAccessor.sharedInstance.getEvents(meetid: meetonlineid!)}
        eventTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        eventList.removeAll()        
        let meetonlineid  = appState.currentMeet?.onlineid
        if meetonlineid != "" {
            eventList = DBAccessor.sharedInstance.getEvents(meetid: meetonlineid!)}
        eventTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventList.count > 0 {
             return eventList.count
        } else {
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventListCell") as! EventListCell
        if eventList.count == 0 {
            cell.eventNameLabel.text = "No Events Scheduled"
            cell.eventTimeLabel.text = ""
            cell.eventTeamLabel.text = ""
        } else {
        let eventData = eventList[indexPath.row]
        cell.eventNameLabel.text = eventData.name
        cell.eventTimeLabel.text = eventData.time
        cell.eventTeamLabel.text = eventData.team
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

}
