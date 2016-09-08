//
//  Game+CoreDataProperties.swift
//  CategoryTiles
//
//  Created by Bill Sylva on 9/7/16.
//  Copyright © 2016 Michael Sylva. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var title: String?
    @NSManaged var complete: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var solution: NSSet?

}
