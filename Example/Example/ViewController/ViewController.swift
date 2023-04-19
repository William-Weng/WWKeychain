//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/04/19.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWKeychain

import UIKit
import WWPrint
import WWKeychain

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        keychainTest()
    }
    
    /// WWKeychain測試
    func keychainTest() {
        
        let urlString = "https://developer.apple.com/videos/play/wwdc2019/262/"
        let newValue = "https://www.appcoda.com.tw/app-security/"
        
        @WWKeychain("PASSWORD") var password: String?
        
        password = urlString
        wwPrint(password)
        
        password = newValue
        wwPrint(password)
        
        password = nil
        wwPrint(password)
    }
}

