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

import Quick
import Nimble
import Nocilla
import Freddy
import SwiftTask
@testable import Astro

// Wait for a task to complete to reduce dependence on `toEventually()` for async tests

extension Task {
    func waitUntilDone() {
        waitUntil(timeout: 5) { done in
            self.then { _, _ in
                done()
            }
        }
    }
}

// Improved DSL for Nocilla

func stubRoute(route: Route) -> LSStubRequestDSL {
    return stubRequest(route.method.rawValue, route.URL.absoluteString).withHeaders(route.URLRequest.allHTTPHeaderFields).withBody(route.URLRequest.HTTPBody)
}

extension LSStubRequestDSL {
    func andReturn(status: HTTPStatusCode) -> LSStubResponseDSL {
        return andReturn(status.rawValue)
    }
}

extension LSStubResponseDSL {
    func withJSON(json: JSON) -> LSStubResponseDSL {
        let body = try? json.serialize() ?? NSData()
        return withHeader("Content-Type", "application/json").withBody(body)
    }
}

func stubAnyRequest() -> LSStubRequestDSL {
    return stubRequest(nil, ".*".regex())
}

