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
}

public typealias HTTPHeaders = [(key: String, value: String)]
public typealias Parameters = [String : Any]

public class JsonRequest<P: GenericResponseParser> {

    private let session: URLSessionProtocol
    private let jsonRequestBuilder = JsonRequestBuilder()
    private let dispatcher: Dispatcher
    
    init(session: URLSessionProtocol = URLSession.shared, dispatcher: Dispatcher) {
        
        self.session = session
        self.dispatcher = dispatcher
    }

    public init(session: URLSessionProtocol = URLSession.shared) {
        
        self.session = session
        self.dispatcher = Dispatcher()
    }

    public func get(url: URL, headers: HTTPHeaders? = nil, success: ((P.GenericResponseEntity?) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        let request = jsonRequestBuilder.defaultJsonRequest(url: url, httpMethod: .get, headers: headers)
        query(request: request, success: success, failure: failure)
    }
    
    public func post(url: URL, body: Parameters? = nil, headers: HTTPHeaders? = nil, success: ((P.GenericResponseEntity?) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        do {
            
            let request = try jsonRequestBuilder.jsonRequest(url: url, httpBody: body, httpMethod: .post, headers: headers)
            query(request: request, success: success, failure: failure)
            
        } catch {
           
            failure?(error)
        }
    }
    
    private func query(request: NSMutableURLRequest, success: ((P.GenericResponseEntity?) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let error = error {
            
                self.handleError(error: error, failure: failure)

            } else if self.isHTTPSuccessResponse(response: response) {
                
                self.handleSuccess(data: data, success: success, failure: failure)
                
            } else {
                
                self.handleError(error: APNetworkingError.requestError, failure: failure)
            }
        }
        
        task.resume()
    }
    
    private func isHTTPSuccessResponse(response: URLResponse?) -> Bool {
        
        if let response = response as? HTTPURLResponse {
            
            return 200...299 ~= response.statusCode
        }
        
        return  false
    }
    
    private func handleError(error: Error, failure: ((Error) -> Void)? = nil) {
        
        dispatcher.async  {
            
            failure?(error)
        }
    }

    private func handleSuccess(data: Data?, success: ((P.GenericResponseEntity?) -> Void)?  = nil, failure: ((Error) -> Void)? = nil) {
        
        let parser = P()
        
        guard let jsonData = data else {
            
            failure?(APNetworkingError.emptyData)
            return
        }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options:[]) as? Json
            
            if let entity = parser.parse(json: json) {
                
                dispatcher.async {
                    success?(entity)
                }
            } else {
                
                handleError(error: APNetworkingError.unexpectedJSON, failure: failure)
            }
            
        } catch {
            
            handleError(error: APNetworkingError.invalidJSON, failure: failure)
        }
    }
}
