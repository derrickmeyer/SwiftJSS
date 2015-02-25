//
//  JSSComunicationClient.swift
//  SwiftJSS
//
//  Created by Tratta, Jason A on 2/13/15.
//  Copyright (c) 2015 Indiana University. All rights reserved.
//

import Foundation



class JSSCommunicationClient : NSURLProtocol {
    
    
    //Properties 
    
    var jssUser: String
    var jssPass: String
    var finished: Bool
    var commDelegate: JSSCommClientDelegate
    var data: NSMutableData
    var connection: NSURLConnection
    
    
    
    init(jssUserParam: String, jssPassParam: String, delegate:JSSCommClientDelegate)  {
        
        
        self.jssUser = jssUserParam
        self.jssPass = jssPassParam
        self.finished = false
        self.commDelegate = delegate
        self.data = NSMutableData()
        self.connection = NSURLConnection()
        
        super.init()
    }
    

 func startWithURL(url: String, jssUserParam: String, jssPassParam: String, jssPath: String, jssDelegate: JSSCommClientDelegate) {
        
        

        jssUser = jssUserParam
        jssPass = jssPassParam
        commDelegate = jssDelegate
        
        
        let urlWithPath = url + jssPath;
        
        let theRequest = NSMutableURLRequest(URL : NSURL(string:urlWithPath)!)
        theRequest.timeoutInterval = 60;
        theRequest.addValue("application/xml", forHTTPHeaderField:"Accept")
    
    
        var theConnection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
    
        theConnection?.start()
    
    }
    
    

    
    
    

    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
    
        println("Connecion Did Recieve Responce")
    }

    
    
    func connection(connection: NSURLConnection!, didReceiveData data1: NSData!) {
        
  
        
           data.appendData(data1)
        
    }
    
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        

        
        commDelegate.connectionSucceeded("Connected")
        commDelegate.dataReturned(data)
            
    
    }
    
    
    
  
    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        
        
        if challenge.previousFailureCount == 0 {
            
            let newCredential = NSURLCredential(user: jssUser, password: jssPass, persistence: NSURLCredentialPersistence.None)
            
            challenge.sender.useCredential(newCredential, forAuthenticationChallenge: challenge)
            
            
        } else {
            
            challenge.sender.cancelAuthenticationChallenge(challenge)
            finished = true
            commDelegate.authFailed("Bad username or Password")
        }

        
    }
    
    
    func connectionShouldUseCredentialStorage(connection: NSURLConnection) -> Bool {
        
        
        println("connectionShouldUseCredentialStorage")
        
        return true
        
    }
    
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        
        println("Fail")
        finished = true
        commDelegate.connectionFailed(String(error.localizedDescription))
        
        
    }
    

    
    
    
    func sendDataWithURL(url: String, jssUserName: String, jssPassword: String, jssPath: String, jssDelegate:JSSCommClientDelegate!, putData: NSData!, method: String) {
        
        
        jssUser = jssUserName
        jssPass = jssPassword
        commDelegate = jssDelegate
        
        let cachePolicy: NSURLRequestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        
        let theURL: NSURL = NSURL(string: url + jssPath)!
        let theRequest = NSMutableURLRequest(URL: theURL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
        
        let dataLength = String(putData.length)
        theRequest.addValue(dataLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("text-html", forHTTPHeaderField: "Content-Type")
        theRequest.HTTPMethod = method
        theRequest.HTTPBody = putData
        
        theRequest.addValue("application/xml", forHTTPHeaderField: "Accept")
        
        
        let theConnection = NSURLConnection(request: theRequest, delegate: self)
        
        
        do {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as NSDate)
        } while !finished
        
    }
    
 
    
    
    

}






