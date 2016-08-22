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

import Alamofire
import Freddy

public struct Route: URLRequestConvertible {
    public let baseURL: NSURL
    public let path: String
    public let method: Alamofire.Method
    public let parameters: RequestParameters?
    public let additionalHeaders: [String: String]

    public init(baseURL: NSURL, path: String, method: Alamofire.Method = .GET, JSON: Freddy.JSON, additionalHeaders: [String: String] = [:]) {
        self.init(baseURL: baseURL, path: path, method: method, parameters: RequestParameters.JSON(parameters: JSON), additionalHeaders: additionalHeaders)
    }

    public init(baseURL: NSURL, path: String, method: Alamofire.Method = .GET, parameters: RequestParameters? = nil, additionalHeaders: [String: String] = [:]) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.additionalHeaders = additionalHeaders
    }

    public var URL: NSURL {
        return baseURL.URLByAppendingPathComponent(self.path)
    }

    // MARK: - URLRequestConvertible

    public var URLRequest: NSMutableURLRequest {
        var mutableURLRequest = NSMutableURLRequest(URL: self.URL)
        mutableURLRequest.HTTPMethod = self.method.rawValue

        for (header, value) in self.additionalHeaders {
            mutableURLRequest.setValue(value, forHTTPHeaderField: header)
        }

        if let parameters = self.parameters {
            mutableURLRequest = parameters.encode(mutableURLRequest).0
        }

        return mutableURLRequest
    }
}

extension Route: CustomStringConvertible {
    public var description: String {
        let request = URLRequest
        let method = request.HTTPMethod ?? ""
        let url = request.URLString ?? ""
        return "\(method) \(url)"
    }
}

public enum RequestParameters {
    case JSON(parameters: Freddy.JSON)
    case Dictionary(parameters: [String: AnyObject], parameterEncoding: Alamofire.ParameterEncoding)

    public func encode(URLRequest: URLRequestConvertible) -> (NSMutableURLRequest, NSError?) {
        switch self {
        case .JSON(let parameters):
            let mutableURLRequest = URLRequest.URLRequest
            var encodingError: NSError? = nil
            do {
                let data = try parameters.serialize()

                if mutableURLRequest.valueForHTTPHeaderField("Content-Type") == nil {
                    mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }

                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
                Log.error("Unable to encode JSON parameters: \(encodingError)")
            }
            return (mutableURLRequest, encodingError)

        case .Dictionary(let parameters, let encoding):
            return encoding.encode(URLRequest, parameters: parameters)
        }
    }
}

public extension String {
    public func base64Encode() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}
