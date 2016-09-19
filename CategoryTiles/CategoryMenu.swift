//
//  CategoryMenu.swift
//  CategoryTiles
//
//  Created by Michael Sylva on 9/10/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class CategoryMenu: SKScene{
    
    var titles = [TitleNode]()
    var lastScroll: CGFloat = 0
    var topLimit: CGFloat = 0
    var bottomLimit: CGFloat = 0
    var listTop: CGFloat = 0
    var listBottom: CGFloat = 0
    var topSpring: CGFloat = 0
    var bottomSpring: CGFloat = 0
    
    var tableView : UITableView!
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print ("categoryMenu didmove")
        let customTable = CategoryView()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 40, width: self.view!.frame.size.width, height: self.view!.frame.size.height-40), style: UITableViewStyle.grouped)
        tableView.delegate = customTable
        tableView.dataSource = customTable
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view?.addSubview(tableView)
    }
}
