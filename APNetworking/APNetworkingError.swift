//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

public enum APNetworkingError: Error {
    
    case unexpectedJSON
    case invalidJSON
    case emptyData
    case failedToSerializeHttpBodyJson
    case requestError
}
