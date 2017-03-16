//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

public typealias Json = [AnyObject]

public protocol GenericResponseParser {
    
    associatedtype GenericResponseEntity

    func parse(json: Json?) -> GenericResponseEntity?
}
