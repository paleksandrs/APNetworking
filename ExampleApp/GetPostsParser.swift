//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import APNetworking

struct GetPostsParser: GenericResponseParser {
    
    typealias GenericReponseEntity = [Post]
    
    func parse(json: Json?) -> [Post]? {
        
        guard  let posts = json as? [[String : Any]] else {
            return nil
        }
        
        return posts.flatMap { return parsePost($0)}
    }
    
   private func parsePost(_ node: [String: Any]) -> Post? {
    
        guard let userId = node["userId"] as? Int,
            let id = node["id"] as? Int,
            let title = node["title"] as? String,
            let body = node["body"] as? String
            else {
        
            return nil
        }
    
        return Post(userId: userId, id: id, title: title, body: body)
    }
}
