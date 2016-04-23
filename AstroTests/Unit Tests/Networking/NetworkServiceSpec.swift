//
//  NetworkServiceSpec.swift
//  GriefSteps
//
//  Created by Cody Rayment on 2016-04-07.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import Quick
import Nimble
import Nocilla
import Alamofire
import Freddy
import SwiftTask
@testable import Astro

class NetworkServiceSpec: QuickSpec {
    override func spec() {
        beforeSuite {
            LSNocilla.sharedInstance().start()
        }
        afterSuite {
            LSNocilla.sharedInstance().stop()
        }
        afterEach {
            LSNocilla.sharedInstance().clearStubs()
        }

        describe("NetworkService") {
            var subject: NetworkService!
            var testJSON: JSON!
            var request: NSMutableURLRequest!

            beforeEach {
                subject = NetworkService()
                testJSON = [
                    "id": "1",
                    "email": "user@example.com",
                ]
                request = NSMutableURLRequest(URL: NSURL(string: "https://example.com/path")!)
            }

            describe(".requestJSONDictionary") {
                var dictTask: Task<Float, ResponseValue<[String: JSON]>, NetworkError>!

                describe("success") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withJSON(testJSON)
                        dictTask = subject.requestJSONDictionary(request)
                    }

                    it("task should be fulfilled") {
                        expect(dictTask.state).toEventually(equal(TaskState.Fulfilled))
                    }
                    it("should eventually return token JSON") {
                        expect({
                            dictTask.value != nil ? JSON.Dictionary(dictTask.value!.value) : nil
                            }()).toEventually(equal(testJSON))
                    }
                }

                describe("401 Unauthorized") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code401Unauthorized).withJSON(["Error": "Unauthorized"])
                        dictTask = subject.requestJSONDictionary(request)
                    }

                    it("task should be rejected") {
                        expect(dictTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("errors on status code") {
                        expect((dictTask.errorInfo?.error?.error as? NSError)?.code).toEventually(equal(Error.Code.StatusCodeValidationFailed.rawValue), timeout: 1)
                    }
                }

                describe("connection error") {
                    var connectionError: NSError!

                    beforeEach {
                        connectionError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo:nil)

                        stubAnyRequest().andFailWithError(connectionError)
                        dictTask = subject.requestJSONDictionary(request)
                    }

                    it("task should be rejected") {
                        expect(dictTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("error should be connectionError") {
                        expect(dictTask.errorInfo?.error?.error as? NSError).toEventually(equal(connectionError))
                    }
                }

                describe("invalid JSON in response") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withBody("not valid JSON!")
                        dictTask = subject.requestJSONDictionary(request)
                    }

                    it("task should be rejected") {
                        expect(dictTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("should fail to parse json") {
                        expect((dictTask.errorInfo?.error?.error as? NSError)?.domain).toEventually(equal("Freddy.JSONParser.Error"))
                    }
                }

                describe("received json [] instead of {}") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withJSON([])
                        dictTask = subject.requestJSONDictionary(request)
                    }

                    it("task should be rejected") {
                        expect(dictTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("should fail to parse json") {
                        let expectedError = JSON.Error.ValueNotConvertible(value: [], to: Swift.Dictionary<String, JSON>)
                        expect({
                            dictTask.errorInfo?.error?.error as? JSON.Error
                        }()).toEventually(equal(expectedError))
                    }
                }
            }

            describe(".requestJSONArray") {
                var arrayTask: Task<Float, ResponseValue<[JSON]>, NetworkError>!

                describe("success") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withJSON([testJSON])
                        arrayTask = subject.requestJSONArray(request)
                    }

                    it("task should be fulfilled") {
                        expect(arrayTask.state).toEventually(equal(TaskState.Fulfilled))
                    }
                    it("should eventually return token JSON") {
                        expect({
                            arrayTask.value != nil ? JSON.Array(arrayTask.value!.value) : nil
                        }()).toEventually(equal([testJSON]))
                    }
                }

                describe("received json {} instead of []") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withJSON([:])
                        arrayTask = subject.requestJSONArray(request)
                    }

                    it("task should be rejected") {
                        expect(arrayTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("should fail to parse json") {
                        let expectedError = JSON.Error.ValueNotConvertible(value: [:], to: Swift.Array<JSON>)
                        expect({
                            arrayTask.errorInfo?.error?.error as? JSON.Error
                        }()).toEventually(equal(expectedError))
                    }
                }
            }

            describe(".requestJSON") {
                var task: Task<Float, ResponseValue<JSON>, NetworkError>!

                describe("200 OK") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withJSON(testJSON)
                        task = subject.requestJSON(request)
                    }

                    it("task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Fulfilled))
                    }
                    it("response should contain response data") {
                        expect({ () -> JSON? in
                            guard let data = task.value?.response?.data else { return nil }
                            return try? JSON(data: data)
                            }()).toEventually(equal(testJSON))
                    }
                    it("response should contain the parsed JSON") {
                        expect(task.value?.value).toEventually(equal(testJSON))
                    }
                }

                describe("status code validation failure") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code404NotFound).withJSON(testJSON)
                        task = subject.requestJSON(request)
                    }

                    it("task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("error should contain response data") {
                        expect({ () -> JSON? in
                            guard let data = task.errorInfo?.error?.response?.data else { return nil }
                            return try? JSON(data: data)
                        }()).toEventually(equal(testJSON))
                    }
                }
            }

            describe(".request<T>") {
                var task: Task<Float, ResponseValue<User>, NetworkError>!

                describe("200 OK") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code200OK).withJSON(testJSON)
                        task = subject.request(request)
                    }
                    it("fulfills with the correct User") {
                        expect({ () -> JSON? in
                            guard let data = task.value?.response?.data else { return nil }
                            return try? JSON(data: data)
                            }()).toEventually(equal(testJSON))
                    }
                    it("response should contain the parsed JSON") {
                        expect(task.value?.value).toEventually(equal(User(userID: "1", email: "user@example.com")))
                    }
                }

                describe("status code validation failure") {
                    beforeEach {
                        stubAnyRequest().andReturn(.Code404NotFound).withJSON(testJSON)
                        task = subject.request(request)
                    }
                    it("task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                    }
                }
            }
        }
    }
}

// Should PR this into Freddy
extension JSON.Error: Equatable {}
public func ==(a: JSON.Error, b: JSON.Error) -> Bool {
    switch (a, b) {
    case (.ValueNotConvertible(let lhsValue, let lhsTo), .ValueNotConvertible(let rhsValue, let rhsTo)):
        return rhsValue == lhsValue &&
            rhsTo == lhsTo
    case (.UnexpectedSubscript(let lhsType), .UnexpectedSubscript(let rhsType)):
        return lhsType == rhsType
    case (.KeyNotFound(let lhsKey), .KeyNotFound(let rhsKey)):
        return lhsKey == rhsKey
    case (.IndexOutOfBounds(let lhsIndex), .IndexOutOfBounds(let rhsIndex)):
        return lhsIndex == rhsIndex
    default: return false
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

