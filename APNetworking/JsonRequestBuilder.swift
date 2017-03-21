//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

class JsonRequestBuilder {
    
    
    func defaultJsonRequest(url: URL, httpMethod: HttpMethod, headers: HTTPHeaders?) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let headers = headers {
            
            for (key, value) in headers {
                
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    func jsonRequest(url: URL, httpBody: Parameters?, httpMethod: HttpMethod, headers: HTTPHeaders?) throws -> NSMutableURLRequest{
        
        let request = defaultJsonRequest(url: url, httpMethod: httpMethod, headers: headers)
        
        if let json = httpBody {
            do {
                
                let body = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                request.httpBody = body
            }catch {
                
                throw APNetworkingError.failedToSerializeHttpBodyJson
            }
        }
        
        return request
    }
}
