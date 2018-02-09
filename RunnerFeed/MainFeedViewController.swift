//
//  MainFeedViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/22/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
import Firebase

class MeetListCell: UITableViewCell {
    @IBOutlet weak var meetName: UILabel!
    @IBOutlet weak var meetDate: UILabel!
    @IBOutlet weak var meetlocation: UILabel!
    
}

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var appState = StateController()
    
    @IBOutlet weak var MeetNameLabel: UILabel!
    @IBOutlet weak var MeetDateLabel: UILabel!
    @IBOutlet weak var TeamNameLabel: UILabel!
    @IBOutlet weak var meetTableView: UITableView!
    var newmeets = [MeetModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appState = (tabBarController as! CustomTabbarController).appState!
        TeamNameLabel.text = appState.currentTeamName
        newmeets = DBAccessor.sharedInstance.getNextMeet()
        if newmeets.count > 0 {
            MeetNameLabel.text = newmeets[0].name
            MeetDateLabel.text = newmeets[0].date
        } else {
            MeetNameLabel.text = "No Upcoming Meets"
            MeetDateLabel.text = ""
        }
        var meetTableHeight :  CGFloat  = CGFloat((newmeets.count*60)+10)
        if meetTableHeight >= 250 {
            meetTableHeight = 250
        }
        meetTableView.translatesAutoresizingMaskIntoConstraints = false
        meetTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        meetTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        meetTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        meetTableView.heightAnchor.constraint(equalToConstant: meetTableHeight).isActive = true
        meetTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        meetTableView.delegate = self
        meetTableView.dataSource = self
        newmeets.removeAll()
        newmeets = DBAccessor.sharedInstance.getNextMeet()
        meetTableView.reloadData()
        if newmeets.count > 0 {
            MeetNameLabel.text = newmeets[0].name
            MeetDateLabel.text = newmeets[0].date
        } else {
            MeetNameLabel.text = "No Upcoming Meets"
            MeetDateLabel.text = ""
        }
    }
    // MARK: LOG OUT BUTTON
    
    @IBOutlet weak var logoutButton: DesignableButton!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print (logoutError)
        }
        
        launchhomeController()
        
    }
    
    
    
    func launchhomeController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
      //  let vc = storyboard.instantiateInitialViewController()
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        vc.appState = self.appState
        navigationController?.pushViewController(vc, animated: true)
       // present(vc, animated: true, completion: nil)
     
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newmeets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = meetTableView.dequeueReusableCell(withIdentifier: "MeetListCell") as! MeetListCell
                let meetData = newmeets[indexPath.row]
                let meetName = meetData.name
                let meetDate = meetData.date
                let meetlocation = meetData.address
                cell.meetName.text = meetName
                cell.meetDate.text = meetDate
                cell.meetlocation.text = meetlocation
        
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appState.currentMeet = newmeets[indexPath.row]
        performSegue(withIdentifier: "showMeetDetails", sender: self)
    }
    
    
 
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeetDetails" {
        guard let DvC = segue.destination as? MeetDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        DvC.appState = appState
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
   
    
}

func getNextMeet(){
    
}


