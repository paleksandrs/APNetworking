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
        var parsedPosts = [Post]()
        
        for post in posts {
            if let parsedPost = parsePost(post) {
                parsedPosts.append(parsedPost)
            } else {
                return nil
            }
        }
        
        return parsedPosts
    }
    
   private func parsePost(_ node: [String: Any]) -> Post? {
    
        guard   let id = node["id"] as? Int,
                let title = node["title"] as? String
            else {
        
            return nil
        }
    
        return Post( id: id, title: title)
    }
}
