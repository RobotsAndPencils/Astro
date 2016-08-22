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
@testable import Astro

class HTTPStatusCodeSpec: QuickSpec {
    override func spec() {
        describe("init(intValue:) - Given we are creating a new HTTPStatusCode") {
            context("when using an enum value that exists") {
                it("then we should get the expected status code") {
                    // Arrange
                    // Act
                    let statusCode = HTTPStatusCode(intValue: HTTPStatusCode.Code200OK.rawValue)
                    // Assert
                    expect(statusCode).to(equal(HTTPStatusCode.Code200OK))
                }
            }
            context("when using an enum value that does not exist") {
                it("then we should get the invalid status code") {
                    // Arrange
                    // Act
                    let statusCode = HTTPStatusCode(intValue: 100000)
                    // Assert
                    expect(statusCode).to(beNil())
                }
            }
        }
        
        describe("Given a Status Code") {
            context("when the code between 100 and 199"){
                it("then it should have an informational status"){
                    expect(HTTPStatusCode.Code100Continue.isInformational).to(beTrue())
                    expect(HTTPStatusCode.Code200OK.isInformational).to(beFalse())
                }
            }
            context("when the code between 200 and 299"){
                it("then it should have a successful status"){
                    expect(HTTPStatusCode.Code101SwitchingProtocols.isSuccessful).to(beFalse())
                    expect(HTTPStatusCode.Code200OK.isSuccessful).to(beTrue())
                    expect(HTTPStatusCode.Code300MultipleChoices.isSuccessful).to(beFalse())
                }
            }
            context("when the code between 300 and 399"){
                it("then should have a redirection status"){
                    expect(HTTPStatusCode.Code206PartialContent.isRedirection).to(beFalse())
                    expect(HTTPStatusCode.Code300MultipleChoices.isRedirection).to(beTrue())
                    expect(HTTPStatusCode.Code400BadRequest.isRedirection).to(beFalse())
                }
            }
            context("when the code between 400 and 499"){
                it("then should have a client error status"){
                    expect(HTTPStatusCode.Code307TemporaryRedirect.isClientError).to(beFalse())
                    expect(HTTPStatusCode.Code400BadRequest.isClientError).to(beTrue())
                    expect(HTTPStatusCode.Code500InternalServerError.isClientError).to(beFalse())
                    expect(HTTPStatusCode.Code429TooManyRequests.isClientError).to(beTrue())
                }
                it("is an error") {
                    expect(HTTPStatusCode.Code307TemporaryRedirect.isError).to(beFalse())
                    expect(HTTPStatusCode.Code400BadRequest.isError).to(beTrue())
                }
            }
            context("when the code between 500 and 599"){
                it("then should have a server error status"){
                    expect(HTTPStatusCode.Code417ExpectationFailed.isServerError).to(beFalse())
                    expect(HTTPStatusCode.Code500InternalServerError.isServerError).to(beTrue())
                }
                it("is an error"){
                    expect(HTTPStatusCode.Code500InternalServerError.isError).to(beTrue())
                }
            }
        }
    }
}
