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
        
        getRequest()
    }
    
    private func getRequest() {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        var customHeaders = HTTPHeaders()
        customHeaders["Custom-Header"] = "Value"
        
        let jsonRequest = JsonRequest<GetPostsParser>()
        
        jsonRequest.get(url: url, headers: customHeaders, success: { (post) in
            
            print("Posts: \(post)")
            
        }) { (error) in
            
            print(error)
        }
    }
    
    private func postRequest() {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let dummyJson = ["key1" : nil, "key2" : "value2"]
   

        let jsonRequest = JsonRequest<EmptyResponse>()
        
        jsonRequest.post(url: url, body: dummyJson, success: { (post) in
            
            print("Posts: \(post)")
            
        }) { (error) in
            
            print(error)
        }
    }
}



