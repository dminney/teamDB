//
//  AddRunnerSwitchCell.swift
//  teamDB
//
//  Created by Dave Minney on 1/2/18.
//  Copyright © 2018 dminn. All rights reserved.
//

import UIKit
protocol AddRunnerCellDelegate {
    func didTapSwitch(cell: AddRunnerCell)
}

class AddRunnerCell: UITableViewCell {

    
    @IBOutlet weak var runnerName: UILabel!
    @IBOutlet weak var runnerTime: UILabel!
    @IBOutlet weak var runnerSwitch: UISwitch!
    
    var delegate : AddRunnerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        delegate?.didTapSwitch(cell: self)
        
    }
    
    func setupwithModel(model : AddRunnerCellModel){
        let runnerFullName =  model.firstname + " " + model.lastname
        //let runnergrade = model.grade
        runnerName.text = runnerFullName
        runnerTime.text = "Ave : 00:00"
        runnerSwitch.setOn(model.competing, animated: false)
    }
}
