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
import SwiftTask
import Freddy

/// Error Type.
public struct NetworkError {
    public let response: DataResponse<Data>?
    public let error: Error

    public var statusCode: HTTPStatusCode? {
        guard let response = response?.response else { return nil }
        return HTTPStatusCode(intValue: response.statusCode)
    }

    public var json: JSON? {
        guard let data = response?.data else { return nil }
        return try? JSON(data: data)
    }

    public init(response: DataResponse<Data>? = nil, error: Error) {
        self.response = response
        self.error = error
    }
}

/// Success Type.
public struct ResponseValue<T> {
    public let response: DataResponse<Data>?
    public let value: T

    public var statusCode: HTTPStatusCode? {
        guard let response = response?.response else { return nil }
        return HTTPStatusCode(intValue: response.statusCode)
    }

    public init(response: DataResponse<Data>? = nil, value: T) {
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
    func request(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<Void>, NetworkError>

    /**
       Performs the specified request for a single object of type T. The response body is
       expected to be a JSON dictionary which is then automatically converted to an
       instance of T using Decodable.

       - parameter URLRequest: the request
       - returns: A task for type T
     */
    func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<T>, NetworkError>
    
    /**
       Performs the specified request for a single object of type T. The response body is
       expected to be a nillable JSON dictionary which is then automatically converted to an
       instance of T using Decodable.
       If the request does not return any data, we will return nil.
     
       - parameter URLRequest: the request
       - returns: A task for type T?
     */
    func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<T?>, NetworkError>
    
    /**
       Performs the specified request for an array of type T. The response body is expected
       to be a JSON array which is then automatically converted to instances of T using
       Decodable. Elements of the array that fail decoding are ignored in this implementation.

       - parameter URLRequest: the request
       - returns: A task for type [T]
     */
    func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[T]>, NetworkError>
    
    /**
       Performs the specified request for an array of type T. The response body is expected
       to be a nillable JSON array which is then automatically converted to instances of T using
       Decodable. Elements of the array that fail decoding are ignored in this implementation.
       If the request does not return any data, we will return nil.
     
       - parameter URLRequest: the request
       - returns: A task for type [T]
     */
    func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[T]?>, NetworkError>
    
    /**
       Performs the specified request for a JSON dictionary.

       - parameter URLRequest: the request
       - returns: A task for a JSON dictionary
     */
    func requestJSONDictionary(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[String: JSON]>, NetworkError>

    /**
       Performs the specified request for a JSON array.

       - parameter URLRequest: the request
       - returns: A task for a JSON array
     */
    func requestJSONArray(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[JSON]>, NetworkError>

    /**
       Performs the specified request for a JSON array.

       - parameter URLRequest: the request
       - returns: A task for a JSON array
     */
    func requestJSONArray(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[JSON]?>, NetworkError>

    /**
       Performs the specified request for some JSON (which may be either an array or a dictionary).

       - parameter URLRequest: the request
       - returns: A task for a JSON object which is either an array or dictionary
     */
    func requestJSON(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<JSON>, NetworkError>

    /**
       Performs the specified request for some JSON (which may be either an array or a dictionary).

       - parameter URLRequest: the request
       - returns: A task for a JSON object which is either an array or dictionary
     */
    func requestJSON(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<JSON?>, NetworkError>

    /**
       Performs the specified request for some data.

       - parameter URLRequest: the request
       - returns: A task for Data
     */
    func requestData(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<Data>, NetworkError>
}

/// Convenience methods without underlying NSHTTPURLResponse
public extension NetworkServiceType {
    func request(_ URLRequest: URLRequestConvertible) -> Task<Float, Void, NetworkError> {
        return request(URLRequest).success { $0.value }
    }

    func request<T:JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, T, NetworkError> {
        return request(URLRequest).success { $0.value }
    }
    
    func request<T:JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, T?, NetworkError> {
        return request(URLRequest).success { $0.value }
    }
    
    func request<T:JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, [T], NetworkError> {
        return request(URLRequest).success { $0.value }
    }
    
    func request<T:JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, [T]?, NetworkError> {
        return request(URLRequest).success { $0.value }
    }
    
    func requestJSONDictionary(_ URLRequest: URLRequestConvertible) -> Task<Float, [String:JSON], NetworkError> {
        return requestJSONDictionary(URLRequest).success { $0.value }
    }

    func requestJSONArray(_ URLRequest: URLRequestConvertible) -> Task<Float, [JSON], NetworkError> {
        return requestJSONArray(URLRequest).success { $0.value }
    }

    func requestJSONArray(_ URLRequest: URLRequestConvertible) -> Task<Float, [JSON]?, NetworkError> {
        return requestJSONArray(URLRequest).success { $0.value }
    }

    func requestJSON(_ URLRequest: URLRequestConvertible) -> Task<Float, JSON, NetworkError> {
        return requestJSON(URLRequest).success { $0.value }
    }

    func requestJSON(_ URLRequest: URLRequestConvertible) -> Task<Float, JSON?, NetworkError> {
        return requestJSON(URLRequest).success { $0.value }
    }

    func requestData(_ URLRequest: URLRequestConvertible) -> Task<Float, Data, NetworkError> {
        return self.requestData(URLRequest).success { return $0.value }
    }
}

/**
   NetworkService is a simple networking layer that assumes usage of Alamofire, SwiftTask, and Freddy. By making these
   assumptions we can provide tasks that directly produce model classes on success and provide Alamofire or JSON errors
   on failure. The NSHTTPURLResponse is provided in both the success and failure case as it is often required to have
   custom behaviour based on something like statusCode. Designed to implement NetworkServiceType so that it can be
   easily mocked.
 */
open class NetworkService: NetworkServiceType {

    public struct AssertionError: Error {}
    fileprivate let requestManager: Alamofire.SessionManager

    public convenience init() {
        let requestManager: Alamofire.SessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

            return Alamofire.SessionManager(configuration: configuration)
        }()
        self.init(requestManager: requestManager)
    }

    public init(requestManager: Alamofire.SessionManager) {
        self.requestManager = requestManager
    }

    open func request(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<Void>, NetworkError> {
        return requestData(URLRequest).success { value in return ResponseValue(response: value.response, value: ()) }
    }

    open func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<T>, NetworkError> {
        return requestJSON(URLRequest).success { (value: ResponseValue<JSON>) -> Task<Float, ResponseValue<T>, NetworkError> in
            let json = value.value
            do {
                let result = try T(json: json)
                return Task(value: ResponseValue(response: value.response, value: result))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }
    
    open func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<T?>, NetworkError> {
        return requestJSON(URLRequest).success { (value: ResponseValue<JSON?>) -> Task<Float, ResponseValue<T?>, NetworkError> in
            guard let json = value.value else {
                return Task(value: ResponseValue(response: value.response, value: nil))
            }
            do {
                let result = try T(json: json)
                return Task(value: ResponseValue(response: value.response, value: result))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }
    
    open func request<T: JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[T]>, NetworkError> {
        return requestJSONArray(URLRequest).success { (value: ResponseValue<[JSON]>) -> Task<Float, ResponseValue<[T]>, NetworkError> in
            let json = value.value
            do {
                let models = try json.map(T.init)
                return Task(value: ResponseValue(response: value.response, value: models))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }
    
    open func request<T:JSONDecodable>(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[T]?>, NetworkError> {
        return requestJSONArray(URLRequest).success { (value: ResponseValue<[JSON]?>) -> Task<Float, ResponseValue<[T]?>, NetworkError> in
            guard let json = value.value else {
                return Task(value: ResponseValue(response: value.response, value: nil))
            }
            do {
                let models = try json.map(T.init)
                return Task(value: ResponseValue(response: value.response, value: models))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }
    
    open func requestJSONDictionary(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[String: JSON]>, NetworkError> {
        return requestJSON(URLRequest).success { (value: ResponseValue<JSON>) -> Task<Float, ResponseValue<[String: JSON]>, NetworkError> in
            let json = value.value
            guard case let JSON.dictionary(dictionary) = json else {
                let error = JSON.Error.valueNotConvertible(value: json, to: Swift.Dictionary<String, JSON>)
                return Task<Float, ResponseValue<[String: JSON]>, NetworkError>(error: NetworkError(response: value.response, error: error))
            }
            return Task(value: ResponseValue(response: value.response, value: dictionary))
        }
    }

    open func requestJSONArray(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[JSON]>, NetworkError> {
        return requestJSON(URLRequest).success { (value: ResponseValue<JSON>) -> Task<Float, ResponseValue<[JSON]>, NetworkError> in
            let json = value.value
            guard case let JSON.array(array) = json else {
                let error = JSON.Error.valueNotConvertible(value: json, to: Swift.Array<JSON>)
                return Task<Float, ResponseValue<[JSON]>, NetworkError>(error: NetworkError(response: value.response, error: error))
            }
            return Task(value: ResponseValue(response: value.response, value: array))
        }
    }
    
    open func requestJSONArray(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<[JSON]?>, NetworkError> {
        return requestJSON(URLRequest).success { (value: ResponseValue<JSON?>) -> Task<Float, ResponseValue<[JSON]?>, NetworkError> in
            guard let json = value.value else {
                return Task(value: ResponseValue(response: value.response, value: nil))
            }
            guard case let JSON.array(array) = json else {
                let error = JSON.Error.valueNotConvertible(value: json, to: Swift.Array<JSON>)
                return Task<Float, ResponseValue<[JSON]?>, NetworkError>(error: NetworkError(response: value.response, error: error))
            }
            return Task(value: ResponseValue(response: value.response, value: array))
        }
    }
    
    open func requestJSON(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<JSON>, NetworkError> {
        return requestData(URLRequest).success { value -> Task<Float, ResponseValue<JSON>, NetworkError> in
            do {
                let json = try JSON(data: value.value)
                return Task(value: ResponseValue(response: value.response, value: json))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }
    
    open func requestJSON(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<JSON?>, NetworkError> {
        return requestData(URLRequest).success { value -> Task<Float, ResponseValue<JSON?>, NetworkError> in
            if value.value.count == 0 {
                return Task(value: ResponseValue(response: value.response, value: nil))
            }
            do {
                let json = try JSON(data: value.value)
                return Task(value: ResponseValue(response: value.response, value: json))
            } catch let error {
                return Task(error: NetworkError(response: value.response, error: error))
            }
        }
    }
    
    open func requestData(_ URLRequest: URLRequestConvertible) -> Task<Float, ResponseValue<Data>, NetworkError> {
        return Task { [weak self] progress, fulfill, reject, configure in
            try? NetworkService.postNotification(NetworkService.Notifications.DidRequest, request: URLRequest)

            let request = self?.requestManager.request(URLRequest)
                .downloadProgress { downloadProgress in
                    progress(Float(downloadProgress.fractionCompleted))
                }
                .validate() // Covers error status code and content type mismatch
                .responseData { response in
                    try? NetworkService.postNotification(NetworkService.Notifications.DidReceive, request: URLRequest, response: response)

                    guard let data = response.result.value , response.result.isSuccess else {
                        // We should always have an error in the non success case but use AssertionError to avoid a bang (!)
                        let error: Error = response.result.error ?? AssertionError()
                        reject(NetworkError(response: response, error: error))
                        return
                    }
                    fulfill(ResponseValue(response: response, value: data))
            }
            configure.cancel = { [weak request] in
                request?.cancel()
            }
        }
    }
}

public extension NetworkService {
    public struct Notifications {
        /**
            Notification for when a request is submitted. The `userInfo` dictionary will contain an instance of `NetworkService.NotificationInfo` via the `NotificationInfoKey` key. For example,
            ```
            func networkServiceDidRequest(notification: Notification) {
                let info = userInfo?[NetworkService.NotificationInfoKey] as? NetworkService.NotificationInfo
                NSLog("request: \(info.request)")
            }
            ```
        */
        public static let DidRequest = "astro.networkingservice.notifications.didRequest"

        /**
            Notification for when a response is received. The `userInfo` dictionary will contain an instance of `NetworkService.NotificationInfo` via the `NotificationInfoKey` key. For example,
            ```
            func networkServiceDidReceive(notification: Notification) {
                let info = userInfo?[NetworkService.NotificationInfoKey] as? NetworkService.NotificationInfo
                NSLog("response: \(info.response)")
            }
            ```
        */
        public static let DidReceive = "astro.networkingservice.notifications.didReceive"
    }

    /**
        The key to the network notification info in the notification `userInfo` dictionary
    */
    public static let NotificationInfoKey = "NotificationInfo"

    /**
     This is a box/wrapper for the request and response because we can't directly add the response to the UserInfo dict (since it's not an NSObject)
    */
    public class NotificationInfo: NSObject {
        /**
            The request that was performed by the NetworkService
        */
        open let request: URLRequest

        /**
            The response that is received in response to `request`. This value will only have a value for the `Notifications.DidReceive` notification.
        */
        open let response: DataResponse<Data>?

        /**
            Creates an instance with the specified request and optional response.
            - parameter request: the request being performed by the NetworkService
            - parameter response: an option response received by the NetworkService
        */
        fileprivate init(request: URLRequestConvertible, response: DataResponse<Data>? = nil) throws {
            self.request = try request.asURLRequest()
            self.response = response
        }
    }

    /**
        Posts a network notification for the given request and response.
        - parameter notficationName: The name of the notification. This should be one of the notification constants in NetworkService.Notifications (.DidRequest and .DidReceive)
        - parameter request: The request made by the network service
        - parameter response: The response received by the network service. This will only have a value for Notifications.DidReceive
    */
    fileprivate static func postNotification(_ notificationName: String, request: URLRequestConvertible, response: DataResponse<Data>? = nil) throws {
        let info = try NotificationInfo(request: request, response: response)
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: self, userInfo: [NetworkService.NotificationInfoKey: info])
    }
}

