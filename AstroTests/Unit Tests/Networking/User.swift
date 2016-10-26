//  Copyright © 2016 Robots and Pencils, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Freddy

struct User {
    let userID: String
    let email: String
}

extension User: JSONDecodable {
    init(json: JSON) throws {
        // Extract id as a string or a int
        if let userID = try? json.getString(at: "id") {
            self.userID = userID
        } else {
            let userID = try json.getInt(at: "id")
            self.userID = String(userID)
        }

        email = try json.getString(at: "email")
    }
}

extension User: JSONEncodable {
    func toJSON() -> JSON {
        return .dictionary([
            "id": .string(userID),
            "email": .string(email)
            ])
    }
}

extension User: Equatable {}
func ==(lhs: User, rhs: User) -> Bool {
    return lhs.email == rhs.email &&
        lhs.userID == rhs.userID
}
