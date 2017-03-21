//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

public typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Swift.Void

public protocol URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
 
    public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {

        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }

}
