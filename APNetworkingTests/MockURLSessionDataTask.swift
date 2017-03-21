//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
@testable import APNetworking

class MockURLSessionDataTask: URLSessionDataTaskProtocol {

    var resumeWasCalled = false
    
    func resume() {
        
        resumeWasCalled = true
    }
    
    func cancel() {
        
    }
}
