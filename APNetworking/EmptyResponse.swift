//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

public struct EmptyResponse: GenericResponseParser {
    
    public typealias GenericReponseEntity = ()
    
    public init() {
        
    }
    
    public func parse(json: Json?) -> GenericReponseEntity? {
        
        return ()
    }
}
