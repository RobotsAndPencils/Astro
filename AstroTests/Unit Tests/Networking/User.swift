//
//  User.swift
//  Astro
//
//  Created by Cody Rayment on 2016-04-23.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import Freddy

struct User {
    let userID: String
    let email: String
}

extension User: JSONDecodable {
    init(json: JSON) throws {
        // Extract id as a string or a int
        if let userID = try? json.string("id") {
            self.userID = userID
        } else {
            let userID = try json.int("id")
            self.userID = String(userID)
        }

        email = try json.string("email")
    }
}

extension User: JSONEncodable {
    func toJSON() -> JSON {
        return .Dictionary([
            "id": .String(userID),
            "email": .String(email)
            ])
    }
}

extension User: Equatable {}
func ==(lhs: User, rhs: User) -> Bool {
    return lhs.email == rhs.email &&
        lhs.userID == rhs.userID
}
