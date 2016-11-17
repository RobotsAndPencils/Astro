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

/**
 Route provides a simple abstraction for working with NSURLRequests. Recommended approach is to add extensions to Route to add a default baseURL value and static functions for your specific API.
 */
public struct Route: URLRequestConvertible {
    public let URL: URL
    public let method: Alamofire.HTTPMethod
    public let parameters: RequestParameters?
    public let additionalHeaders: [String: String]

    public init(URL: URL, method: Alamofire.HTTPMethod = .get, JSON: Freddy.JSON, additionalHeaders: [String: String] = [:]) {
        self.init(URL: URL, method: method, parameters: RequestParameters.json(parameters: JSON), additionalHeaders: additionalHeaders)
    }

    public init(URL: URL, method: Alamofire.HTTPMethod = .get, parameters: RequestParameters? = nil, additionalHeaders: [String: String] = [:]) {
        self.URL = URL
        self.method = method
        self.parameters = parameters
        self.additionalHeaders = additionalHeaders
    }

    // MARK: - URLRequestConvertible

    public func asURLRequest() throws -> URLRequest {
        var mutableURLRequest = URLRequest(url: self.URL)
        mutableURLRequest.httpMethod = self.method.rawValue

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
        do {
            let request = try asURLRequest()
            let method = request.httpMethod ?? ""
            let url = request.url?.absoluteString ?? ""
            return "\(method) \(url)"
        } catch {
            return ""
        }
    }
}

public enum RequestParameters {
    case json(parameters: Freddy.JSON)
    case dictionary(parameters: [String: Any], parameterEncoding: Alamofire.ParameterEncoding)

    public func encode(_ URLRequest: URLRequest) -> (URLRequest, NSError?) {
        switch self {
        case .json(let parameters):
            var mutableURLRequest = URLRequest
            var encodingError: NSError? = nil
            do {
                let data = try parameters.serialize()

                if mutableURLRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }

                mutableURLRequest.httpBody = data
            } catch {
                encodingError = error as NSError
                Log.error("Unable to encode JSON parameters: \(encodingError)")
            }
            return (mutableURLRequest, encodingError)

        case .dictionary(let parameters, let encoding):
            do {
                return (try encoding.encode(URLRequest, with: parameters), nil)
            } catch {
                return (URLRequest, error as NSError)
            }
        }
    }
}

/**
 Allows a String to be base64 encoded so you can safely transport it across the network
 
 - Returns: A new string that has been base64 encoded
 */
public extension String {
    public func base64Encode() -> String {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}
