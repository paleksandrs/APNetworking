//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
@testable import APNetworking

class JsonRequestPutTests: XCTestCase {
    
    private var task: MockURLSessionDataTask!
    private var session: MockURLSession!
    private var url: URL!
    
    override func setUp() {
        super.setUp()
        
        task = MockURLSessionDataTask()
        
        session = MockURLSession()
        session.task = task
        
        url = URL(string: "http://test.com")!
    }
    
    func testCallingPutResumesTaskFromURLSession() {
        
        let request = emptyResponseRequest()
        
        request.put(url: url)
        
        XCTAssertTrue(task.resumeWasCalled)
    }
    
    func testPutRequestIsCorrect() {
        
        let request = emptyResponseRequest()
        
        request.put(url: url)
        
        XCTAssertEqual(session.request!.httpMethod, "PUT")
    }
    
    func testPutRequestHasCorrectHeaders() {
        
        let request = emptyResponseRequest()
        
        request.put(url: url, headers: [(key: "my", value: "header")])
        
        let urlRequest = session.request!
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["my"], "header")
    }
    
    func testWhenCallingPutFailsWithError_ErrorIsReturned() {
        
        session.error = APNetworkingError.requestError
        
        let request = emptyResponseRequest()
        
        var errorFromResponse: Error?
        request.put(url: url, success: nil) { (error) in
            
            errorFromResponse = error
        }
        
        XCTAssertNotNil(errorFromResponse)
    }
    
    func testWhenPutReturnsSuccessStatusCode_SuccessCallbackCalled() {
        
        session.data = "{}".data(using: .utf8)
        
        let request = emptyResponseRequest()
        
        for code in Array(200..<300) {
            
            session.response = successfulResponse(statusCode: code as Int)
            
            var successCalled = false
            request.put(url: url, success: { (_) in
                
                successCalled = true
            })
            
            XCTAssertTrue(successCalled)
        }
    }
    
    func testWhenPutReturnsFailureStatusCode_ErrorReturned() {
        
        let request = emptyResponseRequest()
        
        var failureCode = Array(100..<200)
        failureCode.append(contentsOf: Array(300..<600))
        
        for code in failureCode {
            
            session.response = successfulResponse(statusCode: code as Int)
            
            var errorFromResponse: Error?
            request.put(url: url, success: nil, failure: { (error) in
                
                errorFromResponse = error
            })
            
            XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.requestError)
        }
    }
    
    func testWhenPutReturnsSuccessStatusCode_NilData_EmptyDataErrorReturned() {
        
        session.response = successfulResponse()
        session.data = nil
        
        let request = emptyResponseRequest()
        
        var errorFromResponse: Error?
        request.put(url: url, success: nil) { (error) in
            errorFromResponse = error
        }
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.emptyData)
    }
    
    func testWhenPutReturnsSuccess_ResponseIsSerialized() {
        
        session.response = successfulResponse()
        session.data = "[{\"id\": 1, \"title\": \"title\"}]".data(using: .utf8)
        
        let request = JsonRequest<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var returnedPost: [Post]?
        
        request.put(url: url, success: { (posts) in
            
            returnedPost = posts
        })
        
        XCTAssertNotNil(returnedPost)
        XCTAssertEqual(returnedPost?.count, 1)
    }
    
    func testWhenPutReturnsSuccessWithUnexpectedData_ErrorIsReturned() {
        
        session.response = successfulResponse()
        session.data = "[{\"id\": 1, \"title2\": \"title\"}]".data(using: .utf8)
        
        let request = JsonRequest<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var errorFromResponse: Error?
        request.put(url: url, failure: { error in
            
            errorFromResponse = error
        })
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.unexpectedJSON)
    }
    
    func testWhenPutReturnsSuccessWithInvalidJson_ErrorIsReturned() {
        
        session.response = successfulResponse()
        session.data = "{invalid}".data(using: .utf8)
        
        let request = JsonRequest<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var errorFromResponse: Error?
        request.put(url: url, failure: { error in
            
            errorFromResponse = error
        })
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.invalidJSON)
    }
    
    // MARK: Helpers
    
    private func successfulResponse(statusCode: Int = 200) -> HTTPURLResponse {
        
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    private func emptyResponseRequest() -> JsonRequest<EmptyResponse> {
        
        return  JsonRequest<EmptyResponse>(session: session, dispatcher: MockDispatcher())
    }
    
}
