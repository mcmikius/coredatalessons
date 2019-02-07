//
//  Meal+CoreDataProperties.swift
//  MealTime
//
//  Created by Michail Bondarenko on 2/7/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var person: Person?

}
