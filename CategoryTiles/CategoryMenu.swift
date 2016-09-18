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
    
    var tableView: UITableView = UITableView()

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print ("categoryMenu didmove")
        let table = CategoryView()
        let smallerRect = CGRect(x:100, y:100, width:200, height:100)
        let navRect = CGRect(x:0, y:0, width:200, height:200)
        let nav = UINavigationController(rootViewController: table)
        nav.view.frame = navRect
        
        let frameView = UIView(frame: smallerRect)
        frameView.backgroundColor = UIColor.red
        table.view.frame = frameView.bounds
        
        frameView.addSubview(nav.view)
        self.view?.addSubview(frameView)
        
        
    }
}
