# APNetworking
 [![license MIT](https://img.shields.io/cocoapods/l/JSQCoreDataKit.svg)][mitLink]
 
An easy way to make Rest API calls. 

## Requirements
* Xcode 8
* Swift 3.0
* iOS 9.0+

## Installation

##### [CocoaPods](http://cocoapods.org). Please use the latest CocoaPods as this framework is using Swift 3  

````ruby
use_frameworks!

pod 'APNetworking'

````
## Usage 

##### Use `JsonRequest`to create `post`, `get`, `put`, `delete` requests. Create your own parser confiming to `GenericResponseEntity` and set it for the request using angle brackets and get fully parsed object back. 

````swift
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

let jsonRequest = JsonRequest<GetPostsParser>()
        
jsonRequest.get(url: url, success: { (posts) in

// array of Post objects 
            
}) { (error) in }

````

## License

`APNetworking ` is released under an [MIT License][mitLink]. See `LICENSE` for details.

[mitLink]:http://opensource.org/licenses/MIT
