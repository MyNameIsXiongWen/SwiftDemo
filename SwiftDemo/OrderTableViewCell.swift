//
//  OrderTableViewCell.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/6.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    @IBOutlet weak var orderType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
