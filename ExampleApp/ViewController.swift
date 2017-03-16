//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
import APNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        urlComponents.path = "/posts"
        // urlComponents.queryItems = config.queryItems
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let re = APHTTPRequest(request: request, responseParser: PostParser())
        re.query(success: { (post) in
            
            print(post)
            
        }) { (error) in
            
            print(error)
        }
    }
}



