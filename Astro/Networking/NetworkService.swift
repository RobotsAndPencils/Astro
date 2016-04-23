//
//  NetworkService.swift
//
//  Created by Cody Rayment on 2016-04-07.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import Foundation
import Alamofire
import SwiftTask
import Freddy

/// Error Type.
public struct NetworkError {
    public let response: NSHTTPURLResponse?
    public let error: ErrorType

    public var statusCode: HTTPStatusCode? {
        guard let response = response else { return nil }
        return HTTPStatusCode(intValue: response.statusCode)
    }

    public init(response: NSHTTPURLResponse? = nil, error: ErrorType) {
        self.response = response
        self.error = error
    }
}

/// Success Type.
public struct ResponseValue<T> {
    public let response: NSHTTPURLResponse?
    public let value: T

    public var statusCode: HTTPStatusCode? {
        guard let response = response else { return nil }
        return HTTPStatusCode(intValue: response.statusCode)
    }

    public init(response: NSHTTPURLResponse? = nil, value: T) {
        self.response = response
        self.value = value
    }
}

public protocol NetworkServiceType {
    /**
     Performs the specified request and ignores any returned data. Does not validate that the response is valid JSON. Useful for POSTs where the response body doesn't provide any useful information.

     - parameter URLRequest: the request
     - returns: A task
     */
    func request(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<Void>, NetworkError>

    /**
     Performs the specified request for a single object of type T. The response body is
     expected to be a JSON dictionary which is then automatically converted to an
     instance of T using Decodable.

     - parameter URLRequest: the request
     - returns: A task for type T
     */
    func request<T: JSONDecodable>(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<T>, NetworkError>

    /**
     Performs the specified request for an array of type T. The response body is expected
     to be a JSON array which is then automatically converted to instances of T using
     Decodable. Elements of the array that fail decoding are ignored in this implementation.

     - parameter URLRequest: the request
     - returns: A task for type [T]
     */
    func request<T: JSONDecodable>(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[T]>, NetworkError>

    /**
     Performs the specified request for a JSON dictionary.

     - parameter URLRequest: the request
     - returns: A task for a JSON dictionary
     */
    func requestJSONDictionary(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[String: JSON]>, NetworkError>

    /**
     Performs the specified request for a JSON array.

     - parameter URLRequest: the request
     - returns: A task for a JSON array
     */
    func requestJSONArray(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[JSON]>, NetworkError>

    /**
     Performs the specified request for some JSON (which may be either an array or a dictionary).

     - parameter URLRequest: the request
     - returns: A task for a JSON object which is either an array or dictionary
     */
    func requestJSON(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<JSON>, NetworkError>

    /**
     Performs the specified request for some data.

     - parameter URLRequest: the request
     - returns: A task for NSData
     */
    func requestData(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<NSData>, NetworkError>
}

/// Convenience methods without underlying NSHTTPURLResponse
public extension NetworkServiceType {
    func request(URLRequest: URLRequestConvertible) -> Task<Float, Void, NetworkError> {
        return request(URLRequest).success { $0.value }
    }

    func request<T:JSONDecodable>(URLRequest: URLRequestConvertible) -> Task<Float, T, NetworkError> {
        return request(URLRequest).success { $0.value }
    }

    func request<T:JSONDecodable>(URLRequest: URLRequestConvertible) -> Task<Float, [T], NetworkError> {
        return request(URLRequest).success { $0.value }
    }

    func requestJSONDictionary(URLRequest: URLRequestConvertible) -> Task<Float, [String:JSON], NetworkError> {
        return requestJSONDictionary(URLRequest).success { $0.value }
    }

    func requestJSONArray(URLRequest: URLRequestConvertible) -> Task<Float, [JSON], NetworkError> {
        return requestJSONArray(URLRequest).success { $0.value }
    }

    func requestJSON(URLRequest: URLRequestConvertible) -> Task<Float, JSON, NetworkError> {
        return requestJSON(URLRequest).success { $0.value }
    }

    func requestData(URLRequest: URLRequestConvertible) -> Task<Float, NSData, NetworkError> {
        return self.requestData(URLRequest).success { return $0.value }
    }
}

/**
 NetworkService is a simple networking layer that assumes usage of Alamofire, SwiftTask, and Freddy. By making these assumptions we can provide tasks that directly produce model classes on success and provide Alamofire or JSON errors on failure. The NSHTTPURLResponse is provided in both the success and failure case as it is often required to have custom behaviour based on something like statusCode. Designed to implement NetworkServiceType so that it can be easily mocked.
 */
public class NetworkService: NetworkServiceType {

    public struct AssertionError: ErrorType {}

    public init() {
    }

    public func request(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<Void>, NetworkError> {
        return requestData(URLRequest).success { value in return ResponseValue(response: value.response, value: ()) }
    }

    public func request<T: JSONDecodable>(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<T>, NetworkError> {
        return requestJSON(URLRequest).success { value -> Task<Float, ResponseValue<T>, NetworkError> in
            let json = value.value
            do {
                let result = try T(json: json)
                return Task(value: ResponseValue(response: value.response, value: result))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }

    public func request<T: JSONDecodable>(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[T]>, NetworkError> {
        return requestJSONArray(URLRequest).success { value -> Task<Float, ResponseValue<[T]>, NetworkError> in
            let json = value.value
            do {
                let models = try json.map(T.init)
                return Task(value: ResponseValue(response: value.response, value: models))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }

    public func requestJSONDictionary(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[String: JSON]>, NetworkError> {
        return requestJSON(URLRequest).success { value -> Task<Float, ResponseValue<[String: JSON]>, NetworkError> in
            let json = value.value
            guard case let JSON.Dictionary(dictionary) = json else {
                let error = JSON.Error.ValueNotConvertible(value: json, to: Swift.Dictionary<String, JSON>)
                return Task<Float, ResponseValue<[String: JSON]>, NetworkError>(error: NetworkError(response: value.response, error: error))
            }
            return Task(value: ResponseValue(response: value.response, value: dictionary))
        }
    }

    public func requestJSONArray(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[JSON]>, NetworkError> {
        return requestJSON(URLRequest).success { value -> Task<Float, ResponseValue<[JSON]>, NetworkError> in
            let json = value.value
            guard case let JSON.Array(array) = json else {
                let error = JSON.Error.ValueNotConvertible(value: json, to: Swift.Array<JSON>)
                return Task<Float, ResponseValue<[JSON]>, NetworkError>(error: NetworkError(response: value.response, error: error))
            }
            return Task(value: ResponseValue(response: value.response, value: array))
        }
    }

    public func requestJSON(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<JSON>, NetworkError> {
        return requestData(URLRequest).success { value -> Task<Float, ResponseValue<JSON>, NetworkError> in
            do {
                let json = try JSON(data: value.value)
                return Task(value: ResponseValue(response: value.response, value: json))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }

    public func requestData(URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<NSData>, NetworkError> {
        return Task { [weak self] progress, fulfill, reject, configure in
            let request = self?.requestManager.request(URLRequest)
                .progress { bytesRead, totalBytesRead, totalExpectedBytes -> Void in
                    progress(Float(totalBytesRead) / Float(totalExpectedBytes))
                }
                .validate() // Covers error status code and content type mismatch
                .responseData { response in
                    guard let data = response.result.value where response.result.isSuccess else {
                        // We should always have an error in the non success case but use AssertionError to avoid a bang (!)
                        let error: ErrorType = response.result.error ?? AssertionError()
                        reject(NetworkError(response: response.response, error: error))
                        return
                    }
                    fulfill(ResponseValue(response: response.response, value: data))
            }
            configure.cancel = { [weak request] in
                request?.cancel()
            }
        }
    }

    private let requestManager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders

        return Alamofire.Manager(configuration: configuration)
    }()
}

private extension URLRequestConvertible {
    func logRequest(headers includeHeaders: Bool = false, body includeBody: Bool = false) -> String {
        let request = self.URLRequest
        let method = request.HTTPMethod

        guard let url = request.URL?.absoluteString else {
            return "**Unable to log request**"
        }

        var result = "\(method) \(url)"

        if includeHeaders {
            let headers = request.allHTTPHeaderFields?.map { "\($0): \($1)" }
            if let headers = headers {
                result.appendContentsOf(": \(headers)")
            }
        }

        if includeBody {
            if let bodyData = request.HTTPBody,
                body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                result.appendContentsOf("\n")
                result.appendContentsOf(body)
            }
        }
        return result
    }
}

private extension Response {
    func logResponse(headers includeHeaders: Bool = false, body includeBody: Bool = false) -> String {
        guard let url = request?.URL?.absoluteString,
            statusCodeInt = self.response?.statusCode,
            statusCode = HTTPStatusCode(intValue: statusCodeInt) else {
                return "**Unable to log response**"
        }

        var result = "\(statusCodeInt) \(url)"

        if includeHeaders || statusCode.isError {
            let headers = self.response?.allHeaderFields.map { "\($0): \($1)" }
            if let headers = headers {
                result.appendContentsOf(": \(headers)")
            }
        }

        if includeBody || statusCode.isError {
            if let bodyData = self.data,
                body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                result.appendContentsOf("\n")
                result.appendContentsOf(body)
            }
        }
        return result
    }
}
