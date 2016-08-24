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

import Foundation
import Alamofire

public class NetworkServiceLogger: NSObject {

    public static let sharedInstance = NetworkServiceLogger()

    public var includeHeaders = false
    public var includeBody = true

    deinit {
        stop()
    }

    public func start() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didRequest(_:)), name: NetworkService.Notifications.DidRequest, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didReceive(_:)), name: NetworkService.Notifications.DidReceive, object: nil)
    }

    public func stop() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func didRequest(notification: NSNotification) {
        guard let request = notification.info?.request else { return }

        Log.info(request.debugDescription(headers: includeHeaders, body: includeBody))
    }

    func didReceive(notification: NSNotification) {
        guard let response = notification.info?.response else { return }

        switch response.result {
        case .Failure(let error):
            Log.error(response.debugDescription(headers: includeHeaders, body: includeBody) + ": \(error)")
        case .Success:
            Log.info(response.debugDescription(headers: includeHeaders, body: includeBody))
        }
    }
}

private extension NSNotification {
    var info: NetworkService.NotificationInfo? {
        return userInfo?[NetworkService.NotificationInfoKey] as? NetworkService.NotificationInfo
    }
}

private extension NSMutableURLRequest {
    func debugDescription(headers includeHeaders: Bool = false, body includeBody: Bool = false) -> String {
        let method = HTTPMethod
        let url = URL?.absoluteString ?? ""
        var result = "\(method) \(url)"

        if includeHeaders {
            let headers = allHTTPHeaderFields?.map { "\($0): \($1)" }
            if let headers = headers {
                result.appendContentsOf(": \(headers)")
            }
        }

        if includeBody {
            if let bodyData = HTTPBody,
            body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                result.appendContentsOf("\n")
                result.appendContentsOf(body)
            }
        }
        return result
    }
}

private extension Response {
    func debugDescription(headers includeHeaders: Bool = false, body includeBody: Bool = false) -> String {
        let statusCode = HTTPStatusCode(intValue: response?.statusCode ?? 0)
        let durationMillis = Int(timeline.totalDuration * 1000)
        let url = request?.URL?.absoluteString ?? ""
        let status = statusCode.flatMap { "\($0.rawValue)" } ?? ""
        var result = "[\(durationMillis)ms] \(status) \(url)"

        if includeHeaders || statusCode?.isError == true {
            let headers = response?.allHeaderFields.map { "\($0): \($1)" }
            if let headers = headers {
                result.appendContentsOf(": \(headers)")
            }
        }

        if includeBody || statusCode?.isError == true {
            if let bodyData = self.data,
            body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                result.appendContentsOf("\n")
                result.appendContentsOf(body)
            }
        }
        return result
    }
}
