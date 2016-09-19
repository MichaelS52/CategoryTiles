//
//  ViewController.swift
//  TitleMenuv2
//
//  Created by Michael Sylva on 9/15/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//

import UIKit
class CategoryView: UITableViewController {
    
    var names = ["name1", "name2", "name3"]
    var cats = ["Sports", "Games","test","asa","abvg","awbhfa","asdhata","adsga","afdas"]
    var images = [UIImage(named: "sportssquare"), UIImage(named:"sportssquare")]

    //let customCell = CustomCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel!.text = cats[indexPath.row]
        print("Delegate: ", cats[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("select \(indexPath)")
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print ("tapped \(indexPath)")
    }
}


