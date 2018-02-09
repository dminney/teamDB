//
//  MeetDetailViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/28/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit

class MeetDetailViewController: UIViewController {
 
    var appState : StateController!
    @IBOutlet weak var meetNameLabel: UILabel!
    @IBOutlet weak var meetDateLabel: UILabel!
    @IBOutlet weak var meetAddressLabel: UILabel!
    @IBOutlet weak var meetCityLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        meetNameLabel.text = appState.currentMeet?.name
        meetDateLabel.text = appState.currentMeet?.date
        meetAddressLabel.text = appState.currentMeet?.address
        meetCityLabel.text = "Lagrange,OH 44050"
        // Do any additional setup after loading the view.
    }

   

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case "EventchoiceSegue":
            let destVC = segue.destination as! EventRunnerChoiceController
            destVC.delegate = self
            break
        case "showEventList":
            // Get the new view controller using segue.destinationViewController.
            let destVC = segue.destination as! EventList
             // Pass the selected object to the new view controller.
            destVC.appState = appState
        case "showRunnerList":
            // Get the new view controller using segue.destinationViewController.
            let destVC = segue.destination as! RunnerListViewController
            // Pass the selected object to the new view controller.
            destVC.appState = appState
        default:
            break
        }
    }

}

extension MeetDetailViewController: EventRunnerDelegate {
    
    func eventOrRunnerSelected(choice : Int) {
        switch choice {
        case 0:
            performSegue(withIdentifier: "showEventList", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "showRunnerList", sender: self)
            break
            
        default:
            break
        }
        
    }
}
