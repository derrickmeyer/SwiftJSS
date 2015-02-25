//
//  ViewController.swift
//  SwiftJSS
//
//  Created by Tratta, Jason A on 2/13/15.
//  Copyright (c) 2015 Indiana University. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, JSSCommClientDelegate, NSXMLParserDelegate {
    
    
    @IBOutlet weak var jssAddressTextField: NSTextField!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var passwordSecureText: NSSecureTextField!
    @IBOutlet weak var testButton: NSButton!
    
    @IBOutlet weak var numberOfCPUsLabel: NSTextField!
    
    //Properties
    
     var computerArray: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    
    
    
    @IBAction func testJSS(sender: AnyObject) {
        
        
        
        let address = jssAddressTextField.stringValue
        let username = usernameTextField.stringValue
        let password = passwordSecureText.stringValue
        let thePath = "computers"
        
        self.fetchXMLFromURL(address, jssUserName: username, jssPassword: password, jssPath: thePath)
        
    }
    
    
    
    func fetchXMLFromURL(jssAddr: String, jssUserName:String, jssPassword:String, jssPath: String) {
        
        let commClient = JSSCommunicationClient(jssUserParam: jssAddr, jssPassParam: jssUserName, delegate: self)
        commClient.startWithURL(jssAddr, jssUserParam: jssUserName, jssPassParam: jssPassword, jssPath: "/JSSResource/" + jssPath, jssDelegate: self)
        
        
    }
    
    
    func updateComputerCount() {
        
        var count = computerArray.count
        
        numberOfCPUsLabel.stringValue = String(count)
        
    }

    
    // MARK: Parser Methods
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        
        
        if (elementName == "computer") {
            
            computerArray.append(elementName)
            
        }
        
    }
    
    
    
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        
        updateComputerCount()
        
    }
    
    
    
    
    // MARK: CommClient Delegate Methods
    
    
    
    func dataReturned(data: NSMutableData) {
        
        
        let xmlOption = NSXMLDocumentValidate
        var error: NSErrorPointer? = nil
        var xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
        
        
    }
    
    
    
    func updateStatus(statusMsg: String) {
        
        println("Status:" + statusMsg)
        
        
    }
    
    
    func connectionFailed(errMsg: String){
        
        println("Connection Failed" + errMsg)
        
    }
    
    
    func authFailed(errMsg: String){
        
        println("Auth Failed" + errMsg)
        
        
    }
    
    
    func urlError(errMsg: String){
        
        println("URL Error:" + errMsg)
        
    }
    
    
    func otherError(errMsg: String){
        
        println("Other Message" + errMsg)
    }
    
    func connectionSucceeded(message: String) {
        
        println("Connection Succeeded" + message)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


