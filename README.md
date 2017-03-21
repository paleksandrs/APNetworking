# APNetworking
 [![license MIT](https://img.shields.io/cocoapods/l/JSQCoreDataKit.svg)][mitLink]
 
A convenient way to make Rest API calls and parse data from JSON responses. 

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

````swift
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
let request = JsonRequest<GetPostsParser>()
request.get(url: url, success: { (posts) in

// array of Post objects 
            
}) { (error) in 

}

````

## License

`APNetworking ` is released under an [MIT License][mitLink]. See `LICENSE` for details.

[mitLink]:http://opensource.org/licenses/MIT
