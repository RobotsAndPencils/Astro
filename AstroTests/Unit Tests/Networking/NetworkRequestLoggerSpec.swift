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
@testable import Astro

class NetworkServiceLoggerSpec: QuickSpec {
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

        var subject: NetworkServiceLogger!
        var networkService: NetworkService!
        var json: JSON!
        var request: URLRequest!
        var logRecorder: LogRecorder!

        beforeEach {
            json = [
                "field1": "value1",
                "field2": "value2"
            ]
            request = URLRequest(url: URL(string: "https://example.com/logger/path")!)

            logRecorder = LogRecorder()
            Log.logger = logRecorder
            Log.level = .debug

            networkService = NetworkService()

            subject = NetworkServiceLogger()
        }

        context("not started") {
            beforeEach {
                stubAnyRequest().andReturn(.code200OK).withJSON(json)
                networkService.requestData(request).waitUntilDone()
            }

            it("should not log until started") {
                expect(logRecorder.messages).to(beEmpty())
            }
        }

        context("started") {
            beforeEach {
                subject.start()

                stubAnyRequest().andReturn(.code200OK).withJSON(json)
                networkService.requestData(request).waitUntilDone()
            }

            it("logs send and receive messages") {
                expect(logRecorder.messages).to(haveCount(2))
            }

            context("stopped") {
                beforeEach {
                    logRecorder.messages.removeAll()
                    subject.stop()

                    stubAnyRequest().andReturn(.code200OK).withJSON(json)
                    networkService.requestData(request).waitUntilDone()
                }

                it("should not log after stopping") {
                    expect(logRecorder.messages).to(beEmpty())
                }
            }
        }

        context("network service not retained") {
            beforeEach {
                subject.start()

                stubAnyRequest().andReturn(.code200OK).withJSON(json)

                _ = NetworkService().requestData(request)
            }

            it("should log both send and receive messages") {
                expect(logRecorder.messages).toEventually(haveCount(2))
            }
        }
    }
}
