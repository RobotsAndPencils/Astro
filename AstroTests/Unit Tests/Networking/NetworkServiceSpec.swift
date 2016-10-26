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
            var userJSON: JSON!
            var userArrayJSON: JSON!
            var request: URLRequest!
            let expectedUser = User(userID: "1", email: "user@example.com")
            
            beforeEach {
                subject = NetworkService()
                userJSON = [
                    "id": "1",
                    "email": "user@example.com",
                ]
                userArrayJSON = [userJSON, userJSON]
                request = URLRequest(url: URL(string: "https://example.com/path")!)
            }
            
            describe(".requestJSONDictionary") {
                var dictTask: Task<Float, ResponseValue<[String: JSON]>, NetworkError>!
                
                describe("success") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code200OK).withJSON(userJSON)
                        dictTask = subject.requestJSONDictionary(request)
                    }
                    
                    it("task should be fulfilled") {
                        expect(dictTask.state).toEventually(equal(TaskState.Fulfilled))
                    }
                    it("should eventually return token JSON") {
                        expect({
                            dictTask.value != nil ? JSON.dictionary(dictTask.value!.value) : nil
                            }()).toEventually(equal(userJSON))
                    }
                }
                
                describe("401 Unauthorized") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code401Unauthorized).withJSON(["Error": "Unauthorized"])
                        dictTask = subject.requestJSONDictionary(request)
                    }
                    
                    it("task should be rejected") {
                        expect(dictTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("errors on status code") {
                        let expectedError: AFError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: HTTPStatusCode.code401Unauthorized.rawValue))
                        var error: AFError? = dictTask.errorInfo?.error?.error as? AFError
//                        expect(error).toEventually(equal(expectedError), timeout: 1)
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
                        _ = stubAnyRequest().andReturn(.code200OK).withBody("not valid JSON!" as NSString)
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
                        stubAnyRequest().andReturn(.code200OK).withJSON([])
                        dictTask = subject.requestJSONDictionary(request)
                    }
                    
                    it("task should be rejected") {
                        expect(dictTask.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("should fail to parse json") {
                        let expectedError = JSON.Error.valueNotConvertible(value: [], to: Swift.Dictionary<String, JSON>)
                        expect({
                            dictTask.errorInfo?.error?.error as? JSON.Error
                            }()).toEventually(equal(expectedError))
                    }
                }
            }
            
            describe(".requestJSONArray -> JSON") {
                var arrayTask: Task<Float, ResponseValue<[JSON]>, NetworkError>!
                context("Given a successful response (200 OK)") {
                    context("with a valid array") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userArrayJSON)
                            arrayTask = subject.requestJSONArray(request)
                        }
                        it("then it should fulfill with the correct user JSON") {
                            expect(arrayTask.state).toEventually(equal(TaskState.Fulfilled))
                            expect(arrayTask.value?.value.count).toEventually(equal(2))
                            expect(arrayTask.value?.value[0]).toEventually(equal(userJSON))
                            expect(arrayTask.value?.value[1]).toEventually(equal(userJSON))
                        }
                    }
                    context("with an empty response") {
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            arrayTask = subject.requestJSONArray(request)
                        }
                        it("then the task should be rejected") {
                            expect(arrayTask.state).toEventually(equal(TaskState.Rejected))
                        }
                    }
                }
                context("Given a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        arrayTask = subject.requestJSONArray(request)
                    }
                    it("then task should be rejected") {
                        expect(arrayTask.state).toEventually(equal(TaskState.Rejected))
                    }
                }
                
                describe("Given a invalid json {} instead of []") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code200OK).withJSON([:])
                        arrayTask = subject.requestJSONArray(request)
                    }
                    it("task should be rejected") {
                        expect(arrayTask.state).toEventually(equal(TaskState.Rejected))
                    }
                }
            }
            
            describe(".requestJSONArray -> JSON?") {
                var arrayTask: Task<Float, ResponseValue<[JSON]?>, NetworkError>!
                context("Given a successful response (200 OK)") {
                    context("with a valid array") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userArrayJSON)
                            arrayTask = subject.requestJSONArray(request)
                        }
                        it("then it should fulfill with the correct user JSON") {
                            expect(arrayTask.state).toEventually(equal(TaskState.Fulfilled))
                            expect(arrayTask.value?.value?.count).toEventually(equal(2))
                            expect(arrayTask.value?.value?[0]).toEventually(equal(userJSON))
                            expect(arrayTask.value?.value?[1]).toEventually(equal(userJSON))
                        }
                    }
                    context("with an empty response") {
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            arrayTask = subject.requestJSONArray(request)
                        }
                        it("then the task should be fulfilled") {
                            expect(arrayTask.state).toEventually(equal(TaskState.Fulfilled))
                        }
                        it("then the response should be nil") {
                            expect(arrayTask.state).toEventually(equal(TaskState.Fulfilled))
                            expect(arrayTask.value?.value).to(beNil())
                        }
                    }
                }
                context("Given a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        arrayTask = subject.requestJSONArray(request)
                    }
                    it("then task should be rejected") {
                        expect(arrayTask.state).toEventually(equal(TaskState.Rejected))
                    }
                }

                describe("Given a invalid json {} instead of []") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code200OK).withJSON([:])
                        arrayTask = subject.requestJSONArray(request)
                    }
                    it("task should be rejected") {
                        expect(arrayTask.state).toEventually(equal(TaskState.Rejected))
                    }
                }
            }
            
            describe(".requestJSON -> JSON") {
                var task: Task<Float, ResponseValue<JSON>, NetworkError>!
                context("given a successful response (200 OK)") {
                    context("with a valid object") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userJSON)
                            task = subject.requestJSON(request)
                        }
                        it("then it should fulfill with the correct JSON") {
                            expect({ () -> JSON? in
                                guard let data = task.value?.response?.data else { return nil }
                                return try? JSON(data: data)
                                }()).toEventually(equal(userJSON))
                        }
                        it("then the response should contain the expected User") {
                            expect(task.value?.value).toEventually(equal(userJSON))
                        }
                    }
                    context("with an empty response") {
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            task = subject.requestJSON(request)
                        }
                        it("then the task should be rejected") {
                            expect(task.state).toEventually(equal(TaskState.Rejected))
                        }
                    }
                }
                context("with a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        task = subject.requestJSON(request)
                    }
                    it("then task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                    }
                    it("then the response should not return any JSON"){
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                        expect(task.value?.value).to(beNil())
                    }
                    it("then the response.data should still return the unparsed JSON"){
                        expect({ () -> JSON? in
                            guard let data = task.errorInfo?.error?.response?.data else { return nil }
                            return try? JSON(data: data)
                            }()).toEventually(equal(userJSON))
                    }
                }
            }
            
            describe(".request<T> - Given a request to deserialize an object") {
                var task: Task<Float, ResponseValue<User>, NetworkError>!
                context("given a successful response (200 OK)") {
                    context("with a valid object") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userJSON)
                            task = subject.request(request)
                        }
                        it("then it should fulfill with the correct JSON") {
                            expect({ () -> JSON? in
                                guard let data = task.value?.response?.data else { return nil }
                                return try? JSON(data: data)
                                }()).toEventually(equal(userJSON))
                        }
                        it("then the response should contain the expected User") {
                            expect(task.value?.value).toEventually(equal(expectedUser))
                        }
                    }
                    context("with an empty response") {
                        
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            task = subject.request(request)
                        }
                        it("then the task should be rejected") {
                            expect(task.state).toEventually(equal(TaskState.Rejected))
                        }
                    }
                }
                context("with a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        task = subject.request(request)
                    }
                    it("then task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                    }
                }
            }
            describe(".request<T?> - Given a request to deserialize an nillable object") {
                var task: Task<Float, ResponseValue<User?>, NetworkError>!
                context("Given a successful response (200 OK)") {
                    context("with a valid object") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userJSON)
                            task = subject.request(request)
                        }
                        it("then it should fulfills with the correct JSON") {
                            expect({ () -> JSON? in
                                guard let data = task.value?.response?.data else { return nil }
                                return try? JSON(data: data)
                                }()).toEventually(equal(userJSON))
                        }
                        it("then the response should contain the expected User") {
                            expect(task.value?.value).toEventually(equal(expectedUser))
                        }
                    }
                    context("with an empty response") {
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            task = subject.request(request)
                        }
                        it("then the task should be fulfilled") {
                            expect(task.state).toEventually(equal(TaskState.Fulfilled))
                        }
                        it("then the response should be nil") {
                            expect(task.state).toEventually(equal(TaskState.Fulfilled))
                            expect(task.value?.value).to(beNil())
                        }
                    }
                }
                context("Given a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        task = subject.request(request)
                    }
                    it("then task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                    }
                }
            }
            describe(".request<[T]> - Given a request to deserialize an array of objects") {
                var task: Task<Float, ResponseValue<[User]>, NetworkError>!
                context("Given a successful response (200 OK)") {
                    context("with a valid array") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userArrayJSON)
                            task = subject.request(request)
                        }
                        it("then it should fulfill with the correct Users") {
                            expect(task.state).toEventually(equal(TaskState.Fulfilled))
                            expect(task.value?.value.count).toEventually(equal(2))
                            expect(task.value?.value[0]).toEventually(equal(expectedUser))
                            expect(task.value?.value[1]).toEventually(equal(expectedUser))
                        }
                    }
                    context("with an empty response") {
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            task = subject.request(request)
                        }
                        it("then the task should be rejected") {
                            expect(task.state).toEventually(equal(TaskState.Rejected))
                        }
                    }
                }
                context("Given a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        task = subject.request(request)
                    }
                    it("then task should be rejected") {
                        expect(task.state).toEventually(equal(TaskState.Rejected))
                    }
                }
            }
            describe(".request<[T]?> - Given a request to deserialize a nillable array of object") {
                var task: Task<Float, ResponseValue<[User]?>, NetworkError>!
                context("Given a successful response (200 OK)") {
                    context("with a valid array") {
                        beforeEach {
                            stubAnyRequest().andReturn(.code200OK).withJSON(userArrayJSON)
                            task = subject.request(request)
                        }
                        it("then it should fulfill with the correct user") {
                            expect(task.state).toEventually(equal(TaskState.Fulfilled))
                            expect(task.value?.value?.count).toEventually(equal(2))
                            expect(task.value?.value?[0]).toEventually(equal(expectedUser))
                            expect(task.value?.value?[1]).toEventually(equal(expectedUser))
                        }
                    }
                    context("with an empty response") {
                        beforeEach {
                            _ = stubAnyRequest().andReturn(.code200OK)
                            task = subject.request(request)
                        }
                        it("then the task should be fulfilled") {
                            expect(task.state).toEventually(equal(TaskState.Fulfilled))
                        }
                        it("then the response should be nil") {
                            expect(task.state).toEventually(equal(TaskState.Fulfilled))
                            expect(task.value?.value).to(beNil())
                        }
                    }
                }
                context("Given a failed status code (404 Not Found)") {
                    beforeEach {
                        stubAnyRequest().andReturn(.code404NotFound).withJSON(userJSON)
                        task = subject.request(request)
                    }
                    it("then task should be rejected") {
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
    case (.valueNotConvertible(let lhsValue, let lhsTo), .valueNotConvertible(let rhsValue, let rhsTo)):
        return rhsValue == lhsValue &&
            rhsTo == lhsTo
    case (.unexpectedSubscript(let lhsType), .unexpectedSubscript(let rhsType)):
        return lhsType == rhsType
    case (.keyNotFound(let lhsKey), .keyNotFound(let rhsKey)):
        return lhsKey == rhsKey
    case (.indexOutOfBounds(let lhsIndex), .indexOutOfBounds(let rhsIndex)):
        return lhsIndex == rhsIndex
    default: return false
    }
}
