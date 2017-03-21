//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
