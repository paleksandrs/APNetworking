//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

class JsonTask<P: GenericResponseParser> {
    
    private let session: URLSessionProtocol
    private let dispatcher: Dispatcher
    
    init(session: URLSessionProtocol = URLSession.shared, dispatcher: Dispatcher) {
        
        self.session = session
        self.dispatcher = dispatcher
    }

    func query(request: NSMutableURLRequest?, success: ((P.GenericResponseEntity) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        guard let request = request else {
            
            failure?(APNetworkingError.failedToCreateRequest)
            return
        }
        
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
    
    private func handleSuccess(data: Data?, success: ((P.GenericResponseEntity) -> Void)?  = nil, failure: ((Error) -> Void)? = nil) {
        
        guard let jsonData = data else {
            
            handleError(error: APNetworkingError.emptyData, failure: failure)
            return
        }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options:[]) as? Json
         
            if let entity = P().parse(json: json) {
                
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
