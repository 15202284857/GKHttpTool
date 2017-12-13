//
//  GKHttpTool.swift
//  swift学习
//
//  Created by Apple on 2017/12/13.
//  Copyright © 2017年 郭凯. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
enum RequestType{
    case get
    case post
}
class GKHttpTool{
    //设置manager属性 (重要)
    var manger:SessionManager? = nil
    /// 创建单例
    static let shareInstance : GKHttpTool = {
        let tools = GKHttpTool()
        return tools
    }()
    
    private init() {
        //配置 , 通常默认即可
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        //设置超时时间为15S
        config.timeoutIntervalForRequest = 15
        
        config.httpAdditionalHeaders = ["token":"123"]
        //根据config创建manager
        manger = SessionManager(configuration: config)
    }
}


extension GKHttpTool{

    class func requestData(_ type:RequestType,url:String,params:[String:Any]?=nil,finishedCallBack:@escaping (_ response:Any)->(),failCallBack:@escaping (_ response:Error)->()) {
        //1.获取请求类型
        let method = type == .post ? HTTPMethod.post :HTTPMethod.get
        //2.发送网络请求
        Alamofire.request(url, method: method, parameters: params).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                finishedCallBack(json)
            case .failure(let error):
                print(error)
                failCallBack(error)
            }
        }
    }
    
    
    //发送post请求
    func postRequestData(url:String,params:[String:Any]?=nil,finishedCallBack:@escaping (_ response:Any)->(),failCallBack:@escaping (_ response:Error)->()) {

        manger!.request(url, method: .post, parameters: params).responseJSON { response in

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                finishedCallBack(json)
            case .failure(let error):
                print(error)
                failCallBack(error)
            }
        }
    }
    
    
    //发送get请求
    func getRequestData(url:String,params:[String:Any]?=nil,finishedCallBack:@escaping (_ response:Any)->(),failCallBack:@escaping (_ response:Error)->()) {
  
        manger!.request(url, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                finishedCallBack(json)
            case .failure(let error):
                failCallBack(error)
            }
        }
    }
}

