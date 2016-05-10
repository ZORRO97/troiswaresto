//
//  CoreDataUser+CoreDataProperties.swift
//  troiswaresto
//
//  Created by etudiant-11 on 10/05/2016.
//  Copyright © 2016 francois. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CoreDataUser {

    @NSManaged var email: String?
    @NSManaged var nickname: String?
    @NSManaged var password: String?
    @NSManaged var userId: String?
    @NSManaged var review: NSSet?

}
