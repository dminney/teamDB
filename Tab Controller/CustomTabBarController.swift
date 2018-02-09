//
//  CustomTabBarController.swift
//  teamDB
//
//  Created by Dave Minney on 10/29/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController{
     var appState : StateController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup out custom view controllers
        
        
//        let homeViewController = homeController.self()
//        let homeNavController = UINavigationController(rootViewController: homeViewController)
//        homeNavController.tabBarItem.title = "Home"
//     
//        let runnerviewController = RunnerTableController.self()
//        let runnerNavController = UINavigationController(rootViewController: runnerviewController)
//        runnerNavController.tabBarItem.title = "Runners"
//        
//        let timerViewController = FirstViewController.self()
//            timerViewController.tabBarItem.title = "Timers"
//      
//        viewControllers = [homeNavController,createNavControllerwithTitle(title: "Team"), timerViewController, runnerNavController, createNavControllerwithTitle(title:"more" ) ]
// viewControllers = [homeNavController,createNavControllerwithTitle(title: "Team"), createNavControllerwithTitle(title:"Timers" ), createNavControllerwithTitle(title:"Runners" ), createNavControllerwithTitle(title:"more" ) ]
    }
    
    private func createNavControllerwithTitle(title: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        return navController
    }
}
