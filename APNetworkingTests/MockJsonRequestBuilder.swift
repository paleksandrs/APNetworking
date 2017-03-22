//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
@testable import APNetworking

class MockJsonRequestBuilder: JsonRequestBuilder {
    
    var requestToReturn = NSMutableURLRequest()
    var httpMethod: HttpMethod?
    
    override func jsonRequest(url: URL, httpMethod: HttpMethod, headers: HTTPHeaders?, httpBody: Parameters?) -> NSMutableURLRequest? {
        
        self.httpMethod = httpMethod
        
        return requestToReturn
    }

}
