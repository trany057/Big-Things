//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import Foundation

struct BigThing: Codable {
    let id: String
    let name: String
    let location: String
    let year: String
    let status: String
    let latitude: String
    let longitude: String
    let image: String
    let rating: String
    let votes: String
    let updated: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case year
        case status
        case latitude
        case longitude
        case image
        case rating
        case votes
        case updated
        case description
    }
}
