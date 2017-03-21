//
//  Created by Aleksandrs Proskurins
//
//  License
//  Copyright © 2017 Aleksandrs Proskurins
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
@testable import APNetworking

class JsonRequestGetTests: XCTestCase {
    
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

    func testCallingGetResumesTaskFromURLSession() {

        let request = emptyResponseRequest()
        
        request.get(url: url)
        
        XCTAssertTrue(task.resumeWasCalled)
    }
    
    func testGetRequestIsCorrect() {
        
        let request = emptyResponseRequest()
        
        request.get(url: url)
        
        XCTAssertEqual(session.request!.httpMethod, "GET")
    }
    
    func testGetRequestHasCorrectHeaders() {
        
        let request = emptyResponseRequest()
        
        request.get(url: url, headers: [(key: "my", value: "header")])
        
        let urlRequest = session.request!
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["my"], "header")
    }

    func testWhenCallingGetFailsWithError_ErrorIsReturned() {
        
        session.error = APNetworkingError.requestError
        
        let request = emptyResponseRequest()
        
        var errorFromResponse: Error?
        request.get(url: url, success: nil) { (error) in
            
            errorFromResponse = error
        }
        
        XCTAssertNotNil(errorFromResponse)
    }
    
    func testWhenGetReturnsSuccessStatusCode_SuccessCallbackCalled() {
        
        session.data = "{}".data(using: .utf8)
        
        let request = emptyResponseRequest()
    
        for code in Array(200..<300) {
            
            session.response = successfulResponse(statusCode: code as Int)
            
            var successCalled = false
            request.get(url: url, success: { (_) in
                
                successCalled = true
            })
            
            XCTAssertTrue(successCalled)
        }
    }
    
    func testWhenGetReturnsFailureStatusCode_ErrorReturned() {
        
        let request = emptyResponseRequest()
        
        var failureCode = Array(100..<200)
        failureCode.append(contentsOf: Array(300..<600))
        
        for code in failureCode {
            
            session.response = successfulResponse(statusCode: code as Int)
            
            var errorFromResponse: Error?
            request.get(url: url, success: nil, failure: { (error) in
                
                errorFromResponse = error
            })

            XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.requestError)
        }
    }
    
    func testWhenGetReturnsSuccessStatusCode_NilData_EmptyDataErrorReturned() {
        
        session.response = successfulResponse()
        session.data = nil

        let request = emptyResponseRequest()
    
        var errorFromResponse: Error?
        request.get(url: url, success: nil) { (error) in
            errorFromResponse = error
        }
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.emptyData)
    }
    
    func testWhenGetReturnsSuccess_ResponseIsSerialized() {
        
        session.response = successfulResponse()
        session.data = "[{\"id\": 1, \"title\": \"title\"}]".data(using: .utf8)
    
        let request = JsonRequest<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var returnedPost: [Post]?
        
        request.get(url: url, success: { (posts) in
            
            returnedPost = posts
        })
        
        XCTAssertNotNil(returnedPost)
        XCTAssertEqual(returnedPost?.count, 1)
    }
    
    func testWhenGetReturnsSuccessWithUnexpectedData_ErrorIsReturned() {
        
        session.response = successfulResponse()
        session.data = "[{\"id\": 1, \"title2\": \"title\"}]".data(using: .utf8)
        
        let request = JsonRequest<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var errorFromResponse: Error?
        request.get(url: url, failure: { error in
            
            errorFromResponse = error
        })
        
        XCTAssertEqual(errorFromResponse  as? APNetworkingError, APNetworkingError.unexpectedJSON)
    }
    
    func testWhenGetReturnsSuccessWithInvalidJson_ErrorIsReturned() {
        
        session.response = successfulResponse()
        session.data = "{invalid}".data(using: .utf8)
        
        let request = JsonRequest<GetPostsParser>(session: session, dispatcher: MockDispatcher())
        
        var errorFromResponse: Error?
        request.get(url: url, failure: { error in
            
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
