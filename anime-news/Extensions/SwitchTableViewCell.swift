//
//  SwitchTableViewCell.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/5/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func switchOn(label:String?)
    func switchOff(label:String?)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var `switch`: UISwitch!
    
    var delegate:SwitchCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onValueChange(_ sender: UISwitch) {
        
        if sender.isOn{
            delegate.switchOn(label: self.textLabel?.text)
        }
        else{
            delegate.switchOff(label: self.textLabel?.text)
        }
        //delegate.onValueChange(sender: sender)
    }
    
}
