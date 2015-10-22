//
//  HTTPStatusCode.swift
//  Astro
//
//  Created by Dominic Pepin on 2015-08-28.
//  Copyright (c) 2015 Robots and Pencils. All rights reserved.
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

@objc public enum HTTPStatusCode: Int {
    case InvalidCode = -001

    // Informational - 1xx codes
    case Code100Continue = 100
    case Code101SwitchingProtocols = 101

    // Successful - 2xx codes
    case Code200OK = 200
    case Code201Created = 201
    case Code202Accepted = 202
    case Code203NonAuthoritative = 203
    case Code204NoContent = 204
    case Code205ResetContent = 205
    case Code206PartialContent = 206

    // Redirection - 3xx codes
    case Code300MultipleChoices = 300
    case Code301MovedPermanently = 301
    case Code302Found = 302
    case Code303SeeOther = 303
    case Code304NotModified = 304
    case Code305UseProxy = 305
    case Code307TemporaryRedirect = 307

    // Client errors - 4xx codes
    case Code400BadRequest = 400
    case Code401Unauthorized = 401
    case Code402PaymentRequired = 402
    case Code403Forbidden = 403
    case Code404NotFound = 404
    case Code405MethodNotAllowed = 405
    case Code406NotAcceptable = 406
    case Code407ProxyAuthenticationRequired = 407
    case Code408RequestTimeout = 408
    case Code409Conflict = 409
    case Code410Gone = 410
    case Code411LengthRequired = 411
    case Code412PreconditionFailed = 412
    case Code413RequestEntityTooLarge = 413
    case Code414RequestURITooLong = 414
    case Code415UnsupportedMediaType = 415
    case Code416RequestedRangeNotSatisfiable = 416
    case Code417ExpectationFailed = 417

    // Server errors - 5xx codes
    case Code500InternalServerError = 500
    case Code501NotImplemented = 501
    case Code502BadGateway = 502
    case Code503ServiceUnavailable = 503
    case Code504GatewayTimeout = 504
    case Code505HTTPVersionNotSupported = 505

    // Mark: Properties

    public var description: String {
        switch self {

        case .Code100Continue: return "Continue"
        case .Code101SwitchingProtocols: return "Switching Protocols"
        case .Code200OK: return "OK"
        case .Code201Created: return "Created"
        case .Code202Accepted: return "Accepted"
        case .Code203NonAuthoritative: return "Non Authoritative"
        case .Code204NoContent: return "No Content"
        case .Code205ResetContent: return "Reset Content"
        case .Code206PartialContent: return "Partial Content"
        case .Code300MultipleChoices: return "Multiple Choices"
        case .Code301MovedPermanently: return "Moved Permanently"
        case .Code302Found: return "Found"
        case .Code303SeeOther: return "See Other"
        case .Code304NotModified: return "Not Modified"
        case .Code305UseProxy: return "Use Proxy"
        case .Code307TemporaryRedirect: return "Temporary Redirect"
        case .Code400BadRequest: return "Bad Request"
        case .Code401Unauthorized: return "Unauthorized"
        case .Code402PaymentRequired: return "Payment Required"
        case .Code403Forbidden: return "Forbidden"
        case .Code404NotFound: return "Not Found"
        case .Code405MethodNotAllowed: return "Method Not Allowed"
        case .Code406NotAcceptable: return "Not Acceptable"
        case .Code407ProxyAuthenticationRequired: return "Proxy Authentication Required"
        case .Code408RequestTimeout: return "Request Timeout"
        case .Code409Conflict: return "Conflict"
        case .Code410Gone: return "Gone"
        case .Code411LengthRequired: return "Length Required"
        case .Code412PreconditionFailed: return "Precondition Failed"
        case .Code413RequestEntityTooLarge: return "Request Entity Too Large"
        case .Code414RequestURITooLong: return "Request URI Too Long"
        case .Code415UnsupportedMediaType: return "Unsupported Media Type"
        case .Code416RequestedRangeNotSatisfiable: return "Requested Range Not Satisfiable"
        case .Code417ExpectationFailed: return "Expectation Failed"
        case .Code500InternalServerError: return "Internal Server Error"
        case .Code501NotImplemented: return "Not Implemented"
        case .Code502BadGateway: return "Bad Gateway"
        case .Code503ServiceUnavailable: return "Service Unavailable"
        case .Code504GatewayTimeout: return "Gateway Timeout"
        case .Code505HTTPVersionNotSupported: return "HTTP Version Not Supported"
        case .InvalidCode: fallthrough
        default: return "Invalid Status Code"
        }
    }

    // MARK: Lifecycle

    public init(intValue: Int?) {
        if let intValue = intValue, statusCode = HTTPStatusCode(rawValue: intValue) {
            self = statusCode
        } else {
            self = .InvalidCode
        }
    }

    // MARK: Public

    public func isInformationStatus() -> Bool {
        return rawValue >= 100 && rawValue < 200
    }

    public func isSuccessfulStatus() -> Bool {
        return rawValue >= 200 && rawValue < 300
    }

    public func isRedirectionStatus() -> Bool {
        return rawValue >= 300 && rawValue < 400
    }

    public func isClientErrorStatus() -> Bool {
        return rawValue >= 400 && rawValue < 500
    }

    public func isServerErrorStatus() -> Bool {
        return rawValue >= 500
    }
}
