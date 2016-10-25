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

/**
    A simple logger that listens for NetworkService request/response events and logs the related information in a nicely formatted message for debugging.
*/
open class NetworkServiceLogger: NSObject {

    /**
        Use this instance for the simplest use case. For example, starting the logger can be as simple as:
         ```
            NetworkServiceLogger.sharedInstance.start()
         ```
    */
    open static let sharedInstance = NetworkServiceLogger()

    /**
        Set this option to include or exclude the request and response headers in the formatted log message. Defaults to false (forced to true when logging response errors).
    */
    open var includeHeaders = false

    /**
        Set this option to include or exclude the request and response body in the formatted log message. Defaults to true (forced to true when logging response errors).
    */
    open var includeBody = true

    deinit {
        stop()
    }

    /**
        Starts observing and logging network service notifications.
    */
    open func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRequest(_:)), name: NSNotification.Name(rawValue: NetworkService.Notifications.DidRequest), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceive(_:)), name: NSNotification.Name(rawValue: NetworkService.Notifications.DidReceive), object: nil)
    }

    /**
        Stops observing and logging network service notifications.
    */
    open func stop() {
        NotificationCenter.default.removeObserver(self)
    }

    /**
        Internal method for handling request notifications
    */
    func didRequest(_ notification: Notification) {
        guard let request = notification.info?.request else { return }

        Log.info(request.debugDescription(headers: includeHeaders, body: includeBody))
    }

    /**
        Internal method for handling response notifications
    */
    func didReceive(_ notification: Notification) {
        guard let response = notification.info?.response else { return }

        switch response.result {
        case .failure(let error):
            Log.error(response.debugDescription(headers: includeHeaders, body: includeBody) + ": \(error)")
        case .success:
            Log.info(response.debugDescription(headers: includeHeaders, body: includeBody))
        }
    }
}

private extension Notification {
    /**
        Private convenience extension to make extracting the network info from the notification simple.
    */
    var info: NetworkService.NotificationInfo? {
        return userInfo?[NetworkService.NotificationInfoKey] as? NetworkService.NotificationInfo
    }
}

private extension URLRequest {
    /**
        Private extension for formatting a request into a debug string.
        - parameter headers: option to include request headers in the output
        - parameter body: option to include the request body in the output
        - returns: A formatted string representing the request
    */
    func debugDescription(headers includeHeaders: Bool = false, body includeBody: Bool = false) -> String {
        let method = httpMethod
        let absoluteUrlString = url?.absoluteString ?? ""
        var result = "\(method) \(absoluteUrlString)"

        if includeHeaders {
            let headers = allHTTPHeaderFields?.map { "\($0): \($1)" }
            if let headers = headers {
                result.append(":\n\(headers)\n")
            }
        }

        if includeBody {
            if let bodyData = httpBody,
            let body = String(data: bodyData, encoding: String.Encoding.utf8) {
                result.append("\n")
                result.append(body)
            }
        }
        return result
    }
}

private extension DataResponse {
    /**
        Private extension for formatting a response into a debug string.
        - parameter headers: option to include response headers in the output
        - parameter body: option to include the response body in the output
        - returns: A formatted string representing the response
    */
    func debugDescription(headers includeHeaders: Bool = false, body includeBody: Bool = false) -> String {
        let statusCode = HTTPStatusCode(intValue: response?.statusCode ?? 0)
        let durationMillis = Int(timeline.totalDuration * 1000)
        let url = request?.url?.absoluteString ?? ""
        let status = statusCode.flatMap { "\($0.rawValue)" } ?? ""
        var result = "[\(durationMillis)ms] \(status) \(url)"

        if includeHeaders || statusCode?.isError == true {
            let headers = response?.allHeaderFields.map { "\($0): \($1)" }
            if let headers = headers {
                result.append(":\n\(headers)\n")
            }
        }

        if includeBody || statusCode?.isError == true {
            if let bodyData = self.data,
            let body = String(data: bodyData, encoding: String.Encoding.utf8) {
                result.append("\n")
                result.append(body)
            }
        }
        return result
    }
}
