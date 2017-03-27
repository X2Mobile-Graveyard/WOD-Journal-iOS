//
//  BaseRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import AFNetworking
import UIKit

enum RequestMethod: Int {
    case RequestMethodGET
    case RequestMethodPOST
    case RequestMethodPUT
    case RequestMethodDELETE
}

/*
 
 Access key = AKIAI6TOL2SUOH4DVYMQ
 Secret Key = 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
 
 */

typealias RequestSuccessBlock = (Any?, Any?) -> (Void)
typealias RequestErrorBlock = (Any?, NSError) -> (Void)
typealias RequestExceptionBlock = (AnyObject, NSException) -> (Void)

class BaseRequest: NSObject {
    var showsProgressIndicator: Bool = true
    var hasCustomDisplayErrorMessage: Bool = false
    
    var success: RequestSuccessBlock!
    var error: RequestErrorBlock!
    var exceptionBlock: RequestExceptionBlock!
    var requestSessionManager: AFHTTPSessionManager!
    let ServerBaseURL = "http://wodjar.herokuapp.com/api/v1/"
    
    class func request() -> BaseRequest {
        return BaseRequest()
    }
    
    func serverBase() -> String {
        return ServerBaseURL
    }
    
    func requestURL() -> String {
        return ""
    }
    
    func param() -> Dictionary<String, Any>! {
        return [:]
    }
    
    func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    func successData(data: Any?) -> Any? {
        return data
    }
    
    func headerParams() -> [String: String] {
        return [:]
    }
    
    func sendRequestWithPath(path: String,
                             successBlock: @escaping (URLSessionDataTask, Any?) -> (),
                             failureBlock: ((URLSessionDataTask?, Error) -> Void)?) {
        
        switch requestMethod() {
        case .RequestMethodGET:
            requestSessionManager.get(path, parameters: self.param(), progress: nil, success: successBlock, failure: failureBlock)
        case .RequestMethodPOST:
            requestSessionManager.post(path, parameters: self.param(), progress: nil, success: successBlock, failure: failureBlock)
        case .RequestMethodPUT:
            requestSessionManager.put(path, parameters: self.param(), success: successBlock, failure: failureBlock)
        case .RequestMethodDELETE:
            requestSessionManager.delete(path, parameters: self.param(), success: successBlock, failure: failureBlock)
        }
    }
    
    func runRequest() {
        self.requestSessionManager = AFHTTPSessionManager.init()
        
        self.requestSessionManager.responseSerializer = AFJSONResponseSerializer()
        self.requestSessionManager.requestSerializer = AFJSONRequestSerializer()
        
        let headerParamsDict = headerParams()
        for (key, value) in headerParamsDict {
           self.requestSessionManager.requestSerializer.setValue(value, forHTTPHeaderField: key)
        }
        
        
        let path = self.serverBase().appending((self.requestURL()))
        
        weak var _weakSelf: BaseRequest! = self
        
        let successBlock = { (task: URLSessionDataTask, response: Any?) -> () in
            if self.success != nil {
                _weakSelf.success!(_weakSelf, _weakSelf.successData(data: response))
            }
        }
        
        let failureBlock = { (operation :URLSessionDataTask?, error: Error) -> () in
            if (_weakSelf.error != nil) {
                _weakSelf.error(_weakSelf, error as NSError)
            }
        }
        
        self.sendRequestWithPath(path: path, successBlock: successBlock, failureBlock: failureBlock)
    }
}

