//
//  Keychain.swift
//  Keychain
//
//  Created by William.Weng on 2022/04/19.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/ios/Desktop/WWKeychain

import UIKit
import WWPrint

// MARK: - [利用「屬性包裝器」做成Keychain加強版](https://youtu.be/EBNZF-UbBv0)
// [=> @WWKeychain("PASSWORD") static var password: String?](https://youtu.be/rcRtJyPPjfo)
@propertyWrapper
public struct WWKeychain {
    
    let key: String
    
    public var wrappedValue: String? {
        
        get { return key._readKeychain() }
        
        set {
            
            /// [更新數值 => 做得跟@UserDefaults一樣方便](https://www.jianshu.com/p/139410ed7e15)
            /// - Parameter newValue: [要更新的數值](https://juejin.cn/post/6844904018121064456)
            func _newValueSetting(_ newValue: String?) {
                
                guard let newValue = newValue else { _ = key._removeKeychain(); return }
                
                var result = newValue._storeKeychain(for: key)
                
                switch result {
                case .failure(let error): wwPrint(error)
                case .success(let isSuccess):
                    
                    if (isSuccess) { return }
                    
                    result = newValue._updateKeychain(for: key)
                    
                    switch result {
                    case .failure(let error): wwPrint(error)
                    case .success(let isSuccess): wwPrint(isSuccess)
                    }
                }
            }
 
            _newValueSetting(newValue)
        }
    }
    
    /// 初始化
    /// - Parameter key: 要存入值的key值
    public init(_ key: String) { self.key = key }
}
