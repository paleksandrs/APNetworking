//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

public enum APNetworkingError: Error {
    
    case couldNotParseJSON
    case emptyData
    case requestError(URLResponse?)
}

public class APHTTPRequest<P: GenericResponseParser> {
    
    private var responseParser: P?
    private let session: URLSessionProtocol
    private let request: URLRequest
    private var task: URLSessionDataTaskProtocol?
    
    public init(request:URLRequest, responseParser: P?,session: URLSessionProtocol = URLSession.shared) {
        
        self.session = session
        self.request = request
        self.responseParser = responseParser
    }

    
     
    
    public func query(success: @escaping (P.GenericResponseEntity?) -> Void, failure: @escaping (Error) -> Void) {
        
        task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                DispatchQueue.main.async  {
                    
                    failure(error)
                }

            } else if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                
                self.handleSuccess(data: data, success: success, failure: failure)
                
            } else {
               
                DispatchQueue.main.async  {
                    
                    failure(APNetworkingError.requestError(response))
                }
            }
        }
        
        task?.resume()
    }
    
    private func handleSuccess(data: Data?, success: @escaping (P.GenericResponseEntity?) -> Void, failure: @escaping (Error) -> Void) {
        
        if let parser = responseParser {
            
            parseData(parser: parser, data: data, success: success, failure: failure)
            
        } else {
            
            DispatchQueue.main.async  {
                
                success(nil)
            }
        }
    }
    
    private func parseData(parser: P, data: Data?, success: @escaping (P.GenericResponseEntity?) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let jsonData = data else {
            
            failure(APNetworkingError.emptyData)
            return
        }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options:[]) as? Json
            
            if let entity = parser.parse(json: json) {
                
                DispatchQueue.main.async  {
                    success(entity)
                }
            } else {
                
                DispatchQueue.main.async  {
                    failure(APNetworkingError.couldNotParseJSON)
                }
            }
            
        } catch {
            
            DispatchQueue.main.async  {
                failure(APNetworkingError.couldNotParseJSON)
            }
        }
    }
    
    public func cancel() {
        
        task?.cancel()
    }
}
