//
//  TeamsFoundViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/20/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
import Firebase

class FoundTeamCell: UITableViewCell {
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var mascotLabel: UILabel!
}


class TeamsFoundViewController: UITableViewController {
    var teamList = [TeamInfoModel]()
    var appState = StateController()
    var ref: DatabaseReference!
    
    @IBOutlet var foundTeamTable: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        foundTeamTable.delegate = self
        foundTeamTable.dataSource = self
        ref = Database.database().reference()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teamList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foundTeam", for: indexPath) as! FoundTeamCell

        // Configure the cell...
    
        let teamData = teamList[indexPath.row]
        let teamName = teamData.organization
        let teamCity = teamData.city
        let teamState = teamData.state
        let teamZip = teamData.zipcode
        let teamMascot = teamData.mascot
        
        cell.organizationLabel.text = teamName
        cell.mascotLabel.text = teamMascot
        cell.cityLabel.text = teamCity
        cell.zipcodeLabel.text = String(teamZip)
        cell.stateLabel.text = teamState
        
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        appState.currentTeam = teamList[indexPath.row].id
        matchUserAndTeam()
        
    }

    
    func matchUserAndTeam() {
        guard let team = appState.currentTeam else {
            return
        }
        guard let user = appState.currentUser?.onlineid else {
            return
        }
        
        let newteam = ["team": team, "user": user]
        let TeamRef = self.ref.child("UserTeams").childByAutoId()
        TeamRef.updateChildValues(newteam, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
