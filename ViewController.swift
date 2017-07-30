//
//  ViewController.swift
//  NativeJavascriptApplication
//
//  Created by Nuh Burak Karakaya on 29.07.2017.
//  Copyright © 2017 bk. All rights reserved.
//


/*

    
    Developed By Nuh Burak Karakaya 
    Project was Licanced with GPL 
    Available for Personal Usage 
    Permission must be obtained for Commercial Usage 
    for contact please send an email to burakkarakaya10@gmail.com
 
 
*/

import UIKit
import WebKit
import Foundation
import SQLite
class ViewController: UIViewController,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate  {
    var contentController = WKUserContentController();
    var webView: WKWebView!
    
    override func loadView()
    {
       
        
        //let webConfiguration = WKWebViewConfiguration()
        
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        webView = WKWebView(frame: CGRect.zero, configuration: conf)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.configuration.userContentController.add(self, name: "IOS")

        let htmlFile = Bundle.main.path(forResource: "file", ofType: "html")
        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(html!, baseURL: nil)

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func userContentController(_ userContentController: WKUserContentController!, didReceive message: WKScriptMessage!)
    {
        if(message.name == "IOS")
        {
            print(message.body)
            
            let response    = message.body
            let responseArr = (response as AnyObject).components(separatedBy: " -*-*- ")
            
            let user    = responseArr[0]
            let pass = responseArr[1]
            
            if(DbTool.sharedInstance.isExist(username: user, password: pass))
            {
                Toast.showNegativeMessage(message: "User is already exist!")
            }
            else
            {
                DbTool.sharedInstance.addEntranet(username: user, password: pass)
                Toast.showPositiveMessage(message: "User was Signed UP!")


            }
            
        }
        
    }

}

