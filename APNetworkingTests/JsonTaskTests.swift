//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
@testable import APNetworking

class JsonTaskTests: XCTestCase {
    
    private var task: MockURLSessionDataTask!
    private var session: MockURLSession!
    private var request: NSMutableURLRequest!
    
    override func setUp() {
        super.setUp()
        
        task = MockURLSessionDataTask()
        
        session = MockURLSession()
        session.task = task

        request = NSMutableURLRequest(url: URL(string: "http://test.com")!)
    }
    
    func testCallingQueryResumesTaskFromURLSession() {
        
        let jsonTask = emptyResponseTask()
        
        jsonTask.query(request: request)
        
        XCTAssertTrue(task.resumeWasCalled)
    }

    func testWhenQueryFailsWithError_ErrorIsReturned() {
        
        session.error = APNetworkingError.requestError
        
        let jsonTask = emptyResponseTask()
        
        var errorFromResponse: Error?
        jsonTask.query(request: request, success: nil) { (error) in
            
            errorFromResponse = error
        }
        
        XCTAssertNotNil(errorFromResponse)
    }

    func testWhenQueryReturnsSuccessStatusCode_SuccessCallbackCalled() {
        
        session.data = "{}".data(using: .utf8)
        
        let jsonTask = emptyResponseTask()
        
        for code in Array(200..<300) {
            
            session.response = successfulResponse(statusCode: code as Int)
            
            var successCalled = false
            jsonTask.query(request: request, success: { (_) in
                
                successCalled = true
            })
            
            XCTAssertTrue(successCalled)
        }
    }

    func testWhenQueryReturnsFailureStatusCode_ErrorReturned() {
        
        let jsonTask = emptyResponseTask()
        
        var failureCode = Array(100..<200)
        failureCode.append(contentsOf: Array(300..<600))
        
        for code in failureCode {
            
            session.response = successfulResponse(statusCode: code as Int)
            
            var errorFromResponse: Error?
            jsonTask.query(request: request, success: nil, failure: { (error) in
                
                errorFromResponse = error
            })
            
            XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.requestError)
        }
    }

    func testWhenQueryReturnsSuccessStatusCode_NilData_EmptyDataErrorReturned() {
        
        session.response = successfulResponse()
        session.data = nil
        
        let jsonTask = emptyResponseTask()
        
        var errorFromResponse: Error?
        jsonTask.query(request: request, success: nil) { (error) in
            errorFromResponse = error
        }
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.emptyData)
    }

    func testWhenQueryReturnsSuccess_ResponseIsSerialized() {
        
        session.response = successfulResponse()
        session.data = "[{\"id\": 1, \"title\": \"title\"}]".data(using: .utf8)
        
        let jsonTask = JsonTask<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var returnedPost: [Post]?
        
        jsonTask.query(request: request, success: { (posts) in
            
            returnedPost = posts
        })
        
        XCTAssertNotNil(returnedPost)
        XCTAssertEqual(returnedPost?.count, 1)
    }

    func testWhenQueryReturnsSuccessWithUnexpectedData_ErrorIsReturned() {
        
        session.response = successfulResponse()
        session.data = "[{\"id\": 1, \"title2\": \"title\"}]".data(using: .utf8)
        
        let jsonTask = JsonTask<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var errorFromResponse: Error?
        jsonTask.query(request: request, failure: { error in
            
            errorFromResponse = error
        })
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.unexpectedJSON)
    }

    func testWhenQueryReturnsSuccessWithInvalidJson_ErrorIsReturned() {
        
        session.response = successfulResponse()
        session.data = "{invalid}".data(using: .utf8)
        
        let jsonTask = JsonTask<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var errorFromResponse: Error?
        jsonTask.query(request: request, failure: { error in
            
            errorFromResponse = error
        })
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.invalidJSON)
    }
    
    // MARK: Helpers

    
    private func successfulResponse(statusCode: Int = 200) -> HTTPURLResponse {
        
        return HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    private func emptyResponseTask() -> JsonTask<EmptyResponse> {
        
        return  JsonTask<EmptyResponse>(session: session, dispatcher: MockDispatcher())
    }
}
