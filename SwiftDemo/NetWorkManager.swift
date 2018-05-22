//
//  NetWorkManager.swift
//  SwiftDemo
//
//  Created by jiazhuo1 on 2018/5/21.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType {
    case GET
    case POST
}

class NetWorkManager: AFHTTPSessionManager {
    //单例
    static let sharedNetWorkManager:NetWorkManager = {
        let instance = NetWorkManager()
        let setObject = NSSet.init(array: ["text/html", "text/xml", "application/json", "text/json", "text/javascript", "text/plain"])
//        instance.responseSerializer.acceptableContentTypes?.insert("text/html")
//        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        instance.responseSerializer.acceptableContentTypes = setObject as? Set<String>
        return instance
    }()
    
    func NetWorkRequest(requestType:RequestType, url : String, params: [String : Any], success: @escaping([String : Any]?) ->(),failure: @escaping( _ error : Error?) -> ()) {
        let successBlock = { (dataTask:URLSessionDataTask, responseObject:Any?) -> Void in
            success (responseObject as? [String: Any])
        }
        let failureBlock = { (dataTask:URLSessionDataTask?, error:Error) -> Void in
            failure(error)
        }
        if requestType == .GET {
            get(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
        }
        if requestType == .POST {
            post(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
}
