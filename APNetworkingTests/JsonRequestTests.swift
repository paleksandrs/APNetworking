//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
@testable import APNetworking

class JsonRequestTests: XCTestCase {
    
    private var jsonTask: MockJsonTask<EmptyResponse>!
    private var url: URL!
    private var request: JsonRequest<EmptyResponse>!
    private var requestBuilder: MockJsonRequestBuilder!
    
    override func setUp() {
        super.setUp()
        
        jsonTask = MockJsonTask<EmptyResponse>(session: URLSession.shared, dispatcher: MockDispatcher())
        
        requestBuilder = MockJsonRequestBuilder()
        
        request = JsonRequest<EmptyResponse>(session: URLSession.shared, dispatcher: MockDispatcher(), jsonTask: jsonTask, requestBuilder: requestBuilder)
        
        url = URL(string: "http://test.com")!
    }
    
    func testCallingGetCallsQueryOnJsonTask() {
        
        request.get(url: url)
        
        XCTAssertTrue(jsonTask.queryCalled)
    }
    
    func testCallingGetCallsQueryWithRequestFromBuilder() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.get(url: url)

        XCTAssertEqual(requestBuilder.requestToReturn, jsonTask.request)
    }
    
    func testCallingGetRequestBuilderWithGetHttpMethod() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.get(url: url)

        XCTAssertEqual(requestBuilder.httpMethod?.rawValue, "GET")
    }
    
    func testCallingPostCallsQueryOnJsonTask() {
        
        request.post(url: url)
        
        XCTAssertTrue(jsonTask.queryCalled)
    }
    
    func testCallingPostCallsQueryWithRequestFromBuilder() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.post(url: url)
        
        XCTAssertEqual(requestBuilder.requestToReturn, jsonTask.request)
    }
    
    func testCallingPostRequestBuilderWithGetHttpMethod() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.post(url: url)
        
        XCTAssertEqual(requestBuilder.httpMethod?.rawValue, "POST")
    }
    
    func testCallingDeleteCallsQueryOnJsonTask() {
        
        request.delete(url: url)
        
        XCTAssertTrue(jsonTask.queryCalled)
    }
    
    func testCallingDeleteCallsQueryWithRequestFromBuilder() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.delete(url: url)
        
        XCTAssertEqual(requestBuilder.requestToReturn, jsonTask.request)
    }
    
    func testCallingDeleteRequestBuilderWithGetHttpMethod() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.delete(url: url)
        
        XCTAssertEqual(requestBuilder.httpMethod?.rawValue, "DELETE")
    }
    
    func testCallingPutCallsQueryOnJsonTask() {
        
        request.put(url: url)
        
        XCTAssertTrue(jsonTask.queryCalled)
    }
    
    func testCallingPuteCallsQueryWithRequestFromBuilder() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.put(url: url)
        
        XCTAssertEqual(requestBuilder.requestToReturn, jsonTask.request)
    }
    
    func testCallingPutRequestBuilderWithGetHttpMethod() {
        
        requestBuilder.requestToReturn = NSMutableURLRequest(url: url)
        
        request.put(url: url)
        
        XCTAssertEqual(requestBuilder.httpMethod?.rawValue, "PUT")
    }
}
