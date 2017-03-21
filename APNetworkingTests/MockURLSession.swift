//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
@testable import APNetworking

class MockURLSession: URLSessionProtocol {

    var request: URLRequest?
    var task: URLSessionDataTaskProtocol = MockURLSessionDataTask()
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?
    
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        self.request = request
        completionHandler(data, response, error)
        
        return task
    }
}
