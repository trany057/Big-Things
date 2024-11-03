//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import Foundation

struct Submit: Codable {
    let result: String
    let message: String?
    let rating: String?
    let votes: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case message
        case rating
        case votes
    }
}
