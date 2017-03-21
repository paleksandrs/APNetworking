//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

class Dispatcher {
    
    func async(execute: @escaping @convention(block) () -> Swift.Void) {
        
        DispatchQueue.main.async  {
            
            execute()
        }
    }
}
