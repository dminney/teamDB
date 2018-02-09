//
//  FeedTabViewController.swift
//  teamDB
//
//  Created by Dave Minney on 1/30/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit

class FeedTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "RunnerFeed", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            addChildViewController(controller)
            view.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
        
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
