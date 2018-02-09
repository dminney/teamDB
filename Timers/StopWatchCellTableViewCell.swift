//
//  StopWatchCellTableViewCell.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 11/21/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit

protocol StopwatchDelegate {
    func didTapResetButton(cell: StopWatchCellTableViewCell)
    func didTapStopButton(cell: StopWatchCellTableViewCell)
}

class StopWatchCellTableViewCell: UITableViewCell {

    @IBOutlet weak var runnerNameLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!

    @IBOutlet weak var timerlabel: UILabel!
    @IBOutlet weak var mile1label: UILabel!
    @IBOutlet weak var mile2label: UILabel!
    @IBOutlet weak var splitButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    
    var delegate :StopwatchDelegate?
    
    var timeinterval : Double!
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        delegate?.didTapResetButton(cell:self)
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        delegate?.didTapStopButton(cell: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
