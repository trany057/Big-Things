//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import Foundation
import CoreData

extension BigThing {
    func toEntity(context: NSManagedObjectContext) -> BigThingEntity {
        let bigThingEntity = BigThingEntity(context: context)
        bigThingEntity.id = self.id
        bigThingEntity.name = self.name
        bigThingEntity.location = self.location
        bigThingEntity.year = self.year
        bigThingEntity.status = self.status
        bigThingEntity.latitude = self.latitude
        bigThingEntity.longitude = self.longitude
        bigThingEntity.image = self.image
        bigThingEntity.rating = self.rating
        bigThingEntity.votes = self.votes
        bigThingEntity.updatedDate = self.updated
        bigThingEntity.descriptionText = self.description
        return bigThingEntity
    }
}
