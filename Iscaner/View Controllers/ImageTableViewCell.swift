//
//  ImageTableViewCell.swift
//  Iscaner
//
//  Created by Yogesh Patel on 07/07/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var storedImage: UIImageView!
        
    @IBOutlet weak var imglbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
