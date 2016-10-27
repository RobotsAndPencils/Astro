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
// =================================================================
//
// List of status codes where taken from W3C: http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
//

import Foundation

/**
 HTTPStatusCode is an enum that allows you to clarify status codes returned by your server and includes some more user friendly messaging for failureReason and recoverySuggestion.
 
 Codes are grouped into the following bands:
 
 - Information codes (100-199)
 - Success codes (200-299)
 - Redirection codes (300-399)
 - Client error codes (400-499)
 - Server error codes (>500)
 */
@objc public enum HTTPStatusCode: Int, CustomStringConvertible, CustomDebugStringConvertible {
    // Informational - 1xx codes
    case code100Continue = 100
    case code101SwitchingProtocols = 101

    // Successful - 2xx codes
    case code200OK = 200
    case code201Created = 201
    case code202Accepted = 202
    case code203NonAuthoritative = 203
    case code204NoContent = 204
    case code205ResetContent = 205
    case code206PartialContent = 206

    // Redirection - 3xx codes
    case code300MultipleChoices = 300
    case code301MovedPermanently = 301
    case code302Found = 302
    case code303SeeOther = 303
    case code304NotModified = 304
    case code305UseProxy = 305
    case code307TemporaryRedirect = 307

    // Client errors - 4xx codes
    case code400BadRequest = 400
    case code401Unauthorized = 401
    case code402PaymentRequired = 402
    case code403Forbidden = 403
    case code404NotFound = 404
    case code405MethodNotAllowed = 405
    case code406NotAcceptable = 406
    case code407ProxyAuthenticationRequired = 407
    case code408RequestTimeout = 408
    case code409Conflict = 409
    case code410Gone = 410
    case code411LengthRequired = 411
    case code412PreconditionFailed = 412
    case code413RequestEntityTooLarge = 413
    case code414RequestURITooLong = 414
    case code415UnsupportedMediaType = 415
    case code416RequestedRangeNotSatisfiable = 416
    case code417ExpectationFailed = 417
    case code429TooManyRequests = 429

    // Server errors - 5xx codes
    case code500InternalServerError = 500
    case code501NotImplemented = 501
    case code502BadGateway = 502
    case code503ServiceUnavailable = 503
    case code504GatewayTimeout = 504
    case code505HTTPVersionNotSupported = 505


    // MARK: CustomStringConvertible

    public var description: String {
        return HTTPURLResponse.localizedString(forStatusCode: rawValue).capitalized
    }

    // MARK: CustomDebugStringConvertible

    /**
     - Returns: a detailed string representation (code + string) of this HTTPStatusCode
     */
    public var debugDescription: String {
        return "HTTPStatusCode: \(rawValue) - \(string)"
    }

    /**
     - Returns: a string representation of the HTTPStatusCode
     */
    public var string: String {
        switch self {
        case .code100Continue: return "Continue"
        case .code101SwitchingProtocols: return "Switching Protocols"
        case .code200OK: return "OK"
        case .code201Created: return "Created"
        case .code202Accepted: return "Accepted"
        case .code203NonAuthoritative: return "Non Authoritative"
        case .code204NoContent: return "No Content"
        case .code205ResetContent: return "Reset Content"
        case .code206PartialContent: return "Partial Content"
        case .code300MultipleChoices: return "Multiple Choices"
        case .code301MovedPermanently: return "Moved Permanently"
        case .code302Found: return "Found"
        case .code303SeeOther: return "See Other"
        case .code304NotModified: return "Not Modified"
        case .code305UseProxy: return "Use Proxy"
        case .code307TemporaryRedirect: return "Temporary Redirect"
        case .code400BadRequest: return "Bad Request"
        case .code401Unauthorized: return "Unauthorized"
        case .code402PaymentRequired: return "Payment Required"
        case .code403Forbidden: return "Forbidden"
        case .code404NotFound: return "Not Found"
        case .code405MethodNotAllowed: return "Method Not Allowed"
        case .code406NotAcceptable: return "Not Acceptable"
        case .code407ProxyAuthenticationRequired: return "Proxy Authentication Required"
        case .code408RequestTimeout: return "Request Timeout"
        case .code409Conflict: return "Conflict"
        case .code410Gone: return "Gone"
        case .code411LengthRequired: return "Length Required"
        case .code412PreconditionFailed: return "Precondition Failed"
        case .code413RequestEntityTooLarge: return "Request Entity Too Large"
        case .code414RequestURITooLong: return "Request URI Too Long"
        case .code415UnsupportedMediaType: return "Unsupported Media Type"
        case .code416RequestedRangeNotSatisfiable: return "Requested Range Not Satisfiable"
        case .code417ExpectationFailed: return "Expectation Failed"
        case .code429TooManyRequests: return "Too Many Requests"
        case .code500InternalServerError: return "Internal Server Error"
        case .code501NotImplemented: return "Not Implemented"
        case .code502BadGateway: return "Bad Gateway"
        case .code503ServiceUnavailable: return "Service Unavailable"
        case .code504GatewayTimeout: return "Gateway Timeout"
        case .code505HTTPVersionNotSupported: return "HTTP Version Not Supported"
        }
    }

    // MARK: Lifecycle

    /**
     Initializer that takes a raw HTTP Status Code and creates a HTTPStatusCode representation. Will return nil if the code is not known.
     */
    public init?(intValue: Int) {
        guard let statusCode = HTTPStatusCode(rawValue: intValue) else {
            return nil
        }

        self = statusCode
    }

    // MARK: Public

    /**
     - Returns: true if the HTTPStatusCode is in the range of 100-199
     */
    public var isInformational: Bool {
        return rawValue >= 100 && rawValue < 200
    }

    /**
     - Returns: true if the HTTPStatusCode is in the range of 200-299
     */
    public var isSuccessful: Bool {
        return rawValue >= 200 && rawValue < 300
    }

    /**
     - Returns: true if the HTTPStatusCode is in the range of 300-399
     */
    public var isRedirection: Bool {
        return rawValue >= 300 && rawValue < 400
    }

    /**
     - Returns: true if the HTTPStatusCode is in the range of 400-499
     */
    public var isClientError: Bool {
        return rawValue >= 400 && rawValue < 500
    }

    /**
     - Returns: true if the HTTPStatusCode is in the range of >=500
     */
    public var isServerError: Bool {
        return rawValue >= 500
    }

    /**
     - Returns: true if the HTTPStatusCode is either a Server of Client error (i.e. >= 400)
     */
    public var isError: Bool {
        return isServerError || isClientError
    }
}

extension HTTPStatusCode {
    /**
     - Returns: a more detailed failure reason for this HTTPStatusCode error condition
     */
    public var failureReason: String {
        if !self.isError { return "" }

        switch self {
        // Client errors - 4xx codes
        case .code400BadRequest: return "A bad request was made to the server."
        case .code401Unauthorized: return "An unauthorized request was made to the server."
        case .code402PaymentRequired: return "Payment is required to access this resource."
        case .code403Forbidden: return "Access to that resource is forbidden."
        case .code404NotFound: return "That resource wasn't found."
        case .code405MethodNotAllowed: return "That kind of request isn't allowed."
        case .code406NotAcceptable: return "That request isn't acceptable."
        case .code407ProxyAuthenticationRequired: return "Proxy authentication is required."
        case .code408RequestTimeout: return "The request timed out."
        case .code409Conflict: return "There was a conflict with that resource."
        case .code410Gone: return "That resource is gone."
        case .code411LengthRequired: return "The length of the resource is required."
        case .code412PreconditionFailed: return "A precondition failed."
        case .code413RequestEntityTooLarge: return "The request entity was too large."
        case .code414RequestURITooLong: return "The request URI was too long."
        case .code415UnsupportedMediaType: return "The server doesn't support the type of media in that request."
        case .code416RequestedRangeNotSatisfiable: return "The requested range isn't able to be satisfied by the server."
        case .code417ExpectationFailed: return "An expectation failed."
        case .code429TooManyRequests: return "The user has sent too many requests in a given amount of time."
 
        // Server errors - 5xx codes
        case .code500InternalServerError: return "An error occurred in the server."
        case .code501NotImplemented: return "That feature of the server isn't implemented."
        case .code502BadGateway: return "The gateway is bad."
        case .code503ServiceUnavailable: return "The server is unavailable."
        case .code504GatewayTimeout: return "The request timed out."
        case .code505HTTPVersionNotSupported: return "That HTTP version is unsupported by the server."

        default: return ""
        }
    }

    /**
     - Returns: a suggestion on how you might recover from this HTTPStatusCode error condition
     */
    public var recoverySuggestion: String {
        if !self.isError { return "" }

        switch self {
        // Client errors - 4xx codes
        case .code400BadRequest, .code405MethodNotAllowed, .code406NotAcceptable, .code407ProxyAuthenticationRequired, .code408RequestTimeout, .code409Conflict, .code411LengthRequired, .code412PreconditionFailed, .code413RequestEntityTooLarge, .code414RequestURITooLong, .code415UnsupportedMediaType, .code416RequestedRangeNotSatisfiable, .code417ExpectationFailed:
            return "This is an application error, try signing out and back in again. If this doesn't resolve the issue, please contact support."
        case .code401Unauthorized: return "Try signing out and back in again. If the issue persists, please contact support."
        case .code402PaymentRequired: return "Please make a payment for this resource and try again."
        case .code403Forbidden: return "If the issue persists, please contact support."
        case .code404NotFound: return "If you think this is incorrect, please contact support."
        case .code410Gone: return "If you think this is incorrect, please contact support."
        case .code429TooManyRequests: return "The system has received too many requests and has stopped responding, you can try again shortly but if the issue persists please contact support."

        // Server errors - 5xx codes
        case .code500InternalServerError: return "You can try the same action again, but if the issue persists please contact support."
        case .code501NotImplemented: return ""
        case .code502BadGateway: return "Please contact support if the issue persists."
        case .code503ServiceUnavailable: return "You can try again shortly, but if the issue persists please contact support."
        case .code504GatewayTimeout: return  "You can try again shortly, but if the issue persists please contact support."
        case .code505HTTPVersionNotSupported: return "You can try the same action again, but if the issue persists please contact support."

        default: return ""
        }
    }
}
