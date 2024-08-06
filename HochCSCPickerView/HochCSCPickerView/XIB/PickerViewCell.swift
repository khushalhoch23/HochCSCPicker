//
//  PickerViewCell.swift
//  SQLiteDemo
//
//  Created by Lenovo on 31/07/24.
//

import UIKit

class PickerViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
