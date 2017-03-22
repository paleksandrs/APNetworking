//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

enum HttpMethod: String {
    
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}

public typealias HTTPHeaders = [(key: String, value: String)]
public typealias Parameters = [String : Any]

public class JsonRequest<P: GenericResponseParser> {

    private let session: URLSessionProtocol
    private let requestBuilder: JsonRequestBuilder
    private let dispatcher: Dispatcher
    private let jsonTask: JsonTask<P>
    
    init(session: URLSessionProtocol = URLSession.shared, dispatcher: Dispatcher, jsonTask: JsonTask<P>, requestBuilder: JsonRequestBuilder) {
        
        self.session = session
        self.dispatcher = dispatcher
        self.jsonTask = jsonTask
        self.requestBuilder = requestBuilder
    }

    public init(session: URLSessionProtocol = URLSession.shared) {
        
        self.session = session
        self.dispatcher = Dispatcher()
        self.jsonTask = JsonTask<P>(session: session, dispatcher: dispatcher)
        self.requestBuilder = JsonRequestBuilder()
    }

    public func get(url: URL, headers: HTTPHeaders? = nil, success: ((P.GenericResponseEntity) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        let request = requestBuilder.jsonRequest(url: url, httpMethod: .get, headers: headers)
        jsonTask.query(request: request, success: success, failure: failure)
    }
    
    public func post(url: URL, body: Parameters? = nil, headers: HTTPHeaders? = nil, success: ((P.GenericResponseEntity) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
    
        let request = requestBuilder.jsonRequest(url: url, httpMethod: .post, headers: headers, httpBody: body)
        jsonTask.query(request: request, success: success, failure: failure)
    }
    
    public func put(url: URL, body: Parameters? = nil, headers: HTTPHeaders? = nil, success: ((P.GenericResponseEntity) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        let request = requestBuilder.jsonRequest(url: url, httpMethod: .put, headers: headers, httpBody: body)
        jsonTask.query(request: request, success: success, failure: failure)
    }
    
    public func delete(url: URL, body: Parameters? = nil, headers: HTTPHeaders? = nil, success: ((P.GenericResponseEntity) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        let request = requestBuilder.jsonRequest(url: url, httpMethod: .delete, headers: headers, httpBody: body)
        jsonTask.query(request: request, success: success, failure: failure)
    }
}
