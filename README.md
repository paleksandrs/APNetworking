# APNetworking
 [![license MIT](https://img.shields.io/cocoapods/l/JSQCoreDataKit.svg)][mitLink]
 
A convenient way to make REST API calls and parse data from `JSON` responses. 

## Requirements
* Xcode 8
* Swift 3.0
* iOS 9.0+

## Installation

[CocoaPods](http://cocoapods.org). Please use the latest CocoaPods as this framework is using Swift 3  

````ruby
use_frameworks!

pod 'APNetworking'

````
## Usage 

Use `JsonRequest`to create `post`, `get`, `put` or `delete` request. Create your own parser confirming to `GenericResponseParser`, set it for the request using angle brackets and get fully parsed object back. 


##Example:

Say you have an API call that returns `JSON` of photos:

````json
[
  {
    "albumId": 1,
    "id": 1,
    "title": "accusamus beatae ad facilis cum similique qui sunt",
    "url": "http://placehold.it/600/92c952",
    "thumbnailUrl": "http://placehold.it/150/92c952"
  },
  {
    "albumId": 1,
    "id": 2,
    "title": "reprehenderit est deserunt velit ipsam",
    "url": "http://placehold.it/600/771796",
    "thumbnailUrl": "http://placehold.it/150/771796"
  },
…
]
````

1) Create an object that represents a single photo:

````swift
struct Photo {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
````

2) Create a parser that will be responsible of parsing the response:

````swift
struct GetPhotosParser: GenericResponseParser {
    
    typealias GenericReponseEntity = [Photo]
    
    func parse(json: Json?) -> [Photo]? {
        
        guard  let posts = json as? [[String : Any]] else {
            return nil
        }
        
        return posts.flatMap { return parsePhoto($0)}
    }
    
   private func parsePhoto(_ node: [String: Any]) -> Photo? {
    
        guard let albumId = node["albumId"] as? Int,
            let id = node["id"] as? Int,
            let title = node["title"] as? String,
            let url = node["url"] as? String,
            let thumbnailUrl = node["thumbnailUrl"] as? String
            else {
        
            return nil
        }
    
        return Photo(albumId: albumId, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl)
    }
}
````

3) Make the call: 

````swift
let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
let request = JsonRequest<GetPhotosParser>()

request.get(url: url, success: { photos in    
	for photo in photos {
		print(photo.title)
	}       
}) { (error) in     
	print(error)
}
````

#####Same way you can make `post`, `get`, `put` or `delete` requests. You can also pass custom headers to the call.



## License

`APNetworking ` is released under an [MIT License][mitLink]. See `LICENSE` for details.

[mitLink]:http://opensource.org/licenses/MIT
