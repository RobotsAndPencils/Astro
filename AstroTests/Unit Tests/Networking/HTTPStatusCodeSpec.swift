//
//  HTTPStatusCodeSpec.swift
//  Astro
//
//  Created by Dominic Pepin on 2015-10-21.
//  Copyright © 2015 Robots and Pencils. All rights reserved.
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
                }
            }
            context("when the code between 500 and 599"){
                it("then should have a server error status"){
                    expect(HTTPStatusCode.Code417ExpectationFailed.isServerError).to(beFalse())
                    expect(HTTPStatusCode.Code500InternalServerError.isServerError).to(beTrue())
                }
            }
        }
    }
}
