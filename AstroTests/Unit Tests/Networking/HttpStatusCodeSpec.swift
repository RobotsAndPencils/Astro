//
//  HttpStatusCodeSpec.swift
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
                    // Asssert
                    expect(statusCode).to(equal(HTTPStatusCode.Code200OK))
                }
            }
            context("when using an enum value that does not exist") {
                it("then we should get the invalid status code") {
                    // Arrange
                    // Act
                    let statusCode = HTTPStatusCode(intValue: 100000)
                    // Asssert
                    expect(statusCode).to(equal(HTTPStatusCode.InvalidCode))
                }
            }
        }
        
        describe("Given a Status Code") {
            context("when the code between 100 and 199"){
                it("then it should have an informational status"){
                    expect(HTTPStatusCode.Code100Continue.isInformationStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code200OK.isInformationStatus()).to(beFalse())
                }
            }
            context("when the code between 200 and 299"){
                it("then it should have a successful status"){
                    expect(HTTPStatusCode.Code101SwitchingProtocols.isSuccessfulStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code200OK.isSuccessfulStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code300MultipleChoices.isSuccessfulStatus()).to(beFalse())
                }
            }
            context("when the code between 300 and 399"){
                it("then should have a redirection status"){
                    expect(HTTPStatusCode.Code206PartialContent.isRedirectionStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code300MultipleChoices.isRedirectionStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code400BadRequest.isRedirectionStatus()).to(beFalse())
                }
            }
            context("when the code between 400 and 499"){
                it("then should have a client error status"){
                    expect(HTTPStatusCode.Code307TemporaryRedirect.isClientErrorStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code400BadRequest.isClientErrorStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code500InternalServerError.isClientErrorStatus()).to(beFalse())
                }
            }
            context("when the code between 500 and 599"){
                it("then should have a server error status"){
                    expect(HTTPStatusCode.Code417ExpectationFailed.isServerErrorStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code500InternalServerError.isServerErrorStatus()).to(beTrue())
                }
            }
        }
    }
}
