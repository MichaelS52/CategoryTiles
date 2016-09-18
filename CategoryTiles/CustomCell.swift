//
//  CustomCell.swift
//  TitleMenuv2
//
//  Created by Michael Sylva on 9/15/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
        
        var myLabel = UILabel()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            myLabel.backgroundColor = UIColor.yellow
            self.contentView.addSubview(myLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            myLabel.frame = CGRect(x: 20, y: 0, width: 70, height: 30)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        print ("set selected")
        super.layoutSubviews()
        
        //myLabel.frame = CGRect(x: 20, y: 0, width: 70, height: 30)
    }
}

