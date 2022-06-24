//
//  CartEntity+CoreDataProperties.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 23.06.2022.
//
//

import Foundation
import CoreData


extension CartEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartEntity> {
        return NSFetchRequest<CartEntity>(entityName: "CartEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var price: Int16

}

extension CartEntity : Identifiable {

}
