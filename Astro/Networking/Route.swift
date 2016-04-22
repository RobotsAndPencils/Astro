//
//  Created by Brandon Evans on 2016-01-20.
//  Copyright (c) 2016 Varo Money, Inc. All rights reserved.
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

    private func logRequest(request: NSURLRequest?) {
        let method = request?.HTTPMethod ?? ""
        let url = request?.URLString ?? ""
        Log.info("\(method) \(url)")
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

extension String {
    func base64Encode() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}
