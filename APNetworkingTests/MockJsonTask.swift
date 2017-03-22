//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
@testable import APNetworking

class MockJsonTask<P: GenericResponseParser>: JsonTask<P> {
    
    var request: NSMutableURLRequest?
    var queryCalled = false
    
    override func query(request: NSMutableURLRequest?, success: ((P.GenericResponseEntity) -> Void)?, failure: ((Error) -> Void)?) {
        
        self.request = request
        queryCalled = true
    }
}
