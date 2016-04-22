//
//  HTTPStatusCodeExtensions.swift
//  DecisiveFarming
//
//  Created by Brandon Evans on 2016-01-20.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

extension HTTPStatusCode {
    var failureReason: String {
        if !self.isError { return "" }

        switch self {
        // Client errors - 4xx codes
        case Code400BadRequest: return "A bad request was made to the server."
        case Code401Unauthorized: return "An unauthorized request was made to the server."
        case Code402PaymentRequired: return "Payment is required to access this resource."
        case Code403Forbidden: return "Access to that resource is forbidden."
        case Code404NotFound: return "That resource wasn't found."
        case Code405MethodNotAllowed: return "That kind of request isn't allowed."
        case Code406NotAcceptable: return "That request isn't acceptable."
        case Code407ProxyAuthenticationRequired: return "Proxy authentication is required."
        case Code408RequestTimeout: return "The request timed out."
        case Code409Conflict: return "There was a conflict with that resource."
        case Code410Gone: return "That resource is gone."
        case Code411LengthRequired: return "The length of the resource is required."
        case Code412PreconditionFailed: return "A precondition failed."
        case Code413RequestEntityTooLarge: return "The request entity was too large."
        case Code414RequestURITooLong: return "The request URI was too long."
        case Code415UnsupportedMediaType: return "The server doesn't support the type of media in that request."
        case Code416RequestedRangeNotSatisfiable: return "The requested range isn't able to be satisfied by the server."
        case Code417ExpectationFailed: return "An expectation failed."
            
        // Server errors - 5xx codes
        case Code500InternalServerError: return "An error occurred in the server."
        case Code501NotImplemented: return "That feature of the server isn't implemented."
        case Code502BadGateway: return "The gateway is bad."
        case Code503ServiceUnavailable: return "The server is unavailable."
        case Code504GatewayTimeout: return "The request timed out."
        case Code505HTTPVersionNotSupported: return "That HTTP version is unsupported by the server."
            
        default: return ""
        }
    }
    
    var recoverySuggestion: String {
        if !self.isError { return "" }

        switch self {
        // Client errors - 4xx codes
        case .Code400BadRequest, .Code405MethodNotAllowed, .Code406NotAcceptable, .Code407ProxyAuthenticationRequired, .Code408RequestTimeout, .Code409Conflict, .Code411LengthRequired, .Code412PreconditionFailed, .Code413RequestEntityTooLarge, .Code414RequestURITooLong, .Code415UnsupportedMediaType, .Code416RequestedRangeNotSatisfiable, .Code417ExpectationFailed:
            return "This is an application error, try signing out and back in again. If this doesn't resolve the issue, please contact support."
        case .Code401Unauthorized: return "Try signing out and back in again. If the issue persists, please contact support."
        case .Code402PaymentRequired: return "Please make a payment for this resource and try again."
        case .Code403Forbidden: return "If the issue persists, please contact support."
        case .Code404NotFound: return "If you think this is incorrect, please contact support."
        case .Code410Gone: return "If you think this is incorrect, please contact support."

        // Server errors - 5xx codes
        case .Code500InternalServerError: return "You can try the same action again, but if the issue persists please contact support."
        case .Code501NotImplemented: return ""
        case .Code502BadGateway: return "Please contact support if the issue persists."
        case .Code503ServiceUnavailable: return "You can try again shortly, but if the issue persists please contact support."
        case .Code504GatewayTimeout: return  "You can try again shortly, but if the issue persists please contact support."
        case .Code505HTTPVersionNotSupported: return "You can try the same action again, but if the issue persists please contact support."

        default: return ""
        }
    }
}
