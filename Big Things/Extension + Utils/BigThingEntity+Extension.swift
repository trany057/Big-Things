//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

extension BigThingEntity {
    func toModel() -> BigThing {
        return BigThing(
            id: self.id ?? "",
            name: self.name ?? "",
            location: self.location ?? "",
            year: self.year ?? "",
            status: self.status ?? "",
            latitude: self.latitude ?? "",
            longitude: self.longitude ?? "",
            image: self.image ?? "",
            rating: self.rating ?? "",
            votes: self.votes ?? "",
            updated: self.updatedDate ?? "",
            description: self.descriptionText ?? ""
        )
    }
}
