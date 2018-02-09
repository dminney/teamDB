//
//  mainController.swift
//  teamDB
//
//  Created by Dave Minney on 10/29/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit

class homeController: UIViewController {
    let cclogoView : UIImageView = {
        let imageview = UIImageView(image: #imageLiteral(resourceName: "cc runner"))
         imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(cclogoView)
        // layout constraints
        
        setupLayout()
     
        
    
    }
    
    private func setupLayout()
    {
        cclogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cclogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cclogoView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cclogoView.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
