//
//  StatusTableViewCell.swift
//  CCMStatus
//
//  Created by Johann Garces on 12/12/16.
//  Copyright © 2016 johannmg. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    @IBOutlet weak var endpointName: UILabel!
    @IBOutlet weak var endpointResponseTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    

}
