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
        describe("init(intValue:) - When creating an enum value") {
            context("that exist") {
                it("we shoud get the expected status code") {
                    // Arrange
                    // Act
                    let statusCode = HTTPStatusCode(intValue: HTTPStatusCode.Code200OK.rawValue)
                    // Asssert
                    expect(statusCode).to(equal(HTTPStatusCode.Code200OK))
                }
            }
            context("that does not exist") {
                it("we shoud get the invalid status code") {
                    // Arrange
                    // Act
                    let statusCode = HTTPStatusCode(intValue: 100000)
                    // Asssert
                    expect(statusCode).to(equal(HTTPStatusCode.InvalidCode))
                }
            }
        }
        
        describe("Status Codes") {
            context("between 100 and 199"){
                it("should be information status code"){
                    expect(HTTPStatusCode.Code100Continue.isInformationStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code200OK.isInformationStatus()).to(beFalse())
                }
            }
            context("between 200 and 299"){
                it("should be success status code"){
                    expect(HTTPStatusCode.Code101SwitchingProtocols.isSuccessfulStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code200OK.isSuccessfulStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code300MultipleChoices.isSuccessfulStatus()).to(beFalse())
                }
            }
            context("between 300 and 399"){
                it("should be redirection status code"){
                    expect(HTTPStatusCode.Code206PartialContent.isRedirectionStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code300MultipleChoices.isRedirectionStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code400BadRequest.isRedirectionStatus()).to(beFalse())
                }
            }
            context("between 400 and 499"){
                it("should be client error status code"){
                    expect(HTTPStatusCode.Code307TemporaryRedirect.isClientErrorStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code400BadRequest.isClientErrorStatus()).to(beTrue())
                    expect(HTTPStatusCode.Code500InternalServerError.isClientErrorStatus()).to(beFalse())
                }
            }
            context("between 500 and 599"){
                it("should be server error status code"){
                    expect(HTTPStatusCode.Code417ExpectationFailed.isServerErrorStatus()).to(beFalse())
                    expect(HTTPStatusCode.Code500InternalServerError.isServerErrorStatus()).to(beTrue())
                }
            }
        }
    }
}
