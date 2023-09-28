//
//  Extension.swift
//  Keychain
//
//  Created by William.Weng on 2023/4/19.
//

import UIKit

// MARK: - Data
extension Data {
    
    /// Data => 字串
    /// - Parameter encoding: 字元編碼
    /// - Returns: String?
    func _string(using encoding: String.Encoding = .utf8) -> String? {
        return String(bytes: self, encoding: encoding)
    }
}

// MARK: - String
extension String {
    
    /// String => Data
    /// - Parameters:
    ///   - encoding: 字元編碼
    ///   - isLossyConversion: 失真轉換
    /// - Returns: Data?
    func _data(using encoding: String.Encoding = .utf8, isLossyConversion: Bool = false) -> Data? {
        let data = self.data(using: encoding, allowLossyConversion: isLossyConversion)
        return data
    }
    
    /// [儲存Keychain => <value>._storeKeychain(for:encoding:)](https://dnz-think.medium.com/swift-keychain-6489bd09b51)
    /// - Parameters:
    ///   - key: 要儲存資料的代號
    ///   - encoding: 資料編碼
    /// - Returns: Bool
    func _storeKeychain(for key: String, encoding: String.Encoding = .utf8) -> Result<Bool, Error> {
        
        guard let data = self._data(using: encoding) else { return .failure(MyError.notEncoding) }
        
        let query: [CFString : Any] = [kSecAttrAccount: key, kSecValueData: data, kSecClass: kSecClassGenericPassword]
        let status = _SecItemAdd(query: query, result: nil)
        
        return .success(status == errSecSuccess)
    }
        
    /// [更新Keychain => <value>._updateKeychain(for:encoding:)](https://www.jianshu.com/p/31e5654166db)
    /// - Parameters:
    ///   - key: 要儲存資料的代號
    ///   - encoding: 資料編碼
    /// - Returns: Bool
    func _updateKeychain(for key: String, encoding: String.Encoding = .utf8) -> Result<Bool, Error>  {
        
        guard let data = self._data(using: encoding) else { return .failure(MyError.notEncoding) }

        let query: [CFString : Any] = [kSecAttrAccount: key, kSecClass: kSecClassGenericPassword]
        let fields = [kSecValueData: data]
        let status = _SecItemUpdate(query: query, fields: fields)
        
        return .success(status == errSecSuccess)
    }
    
    /// [讀取Keychain => <key>._readKeychain(encoding:)](https://www.appcoda.com.tw/app-security/)
    /// - Parameters:
    ///   - encoding: 資料編碼
    /// - Returns: String?
    func _readKeychain(encoding: String.Encoding = .utf8) -> String? {

        var item: AnyObject?

        let query: [CFString : Any] = [kSecAttrAccount: self, kSecReturnData: true, kSecClass: kSecClassGenericPassword, kSecMatchLimit: kSecMatchLimitOne]
        let status = withUnsafeMutablePointer(to: &item) { _SecItemCopyMatching(query: query, result: UnsafeMutablePointer($0)) }
        
        guard status == errSecSuccess,
              let data = item as? Data
        else {
            return nil
        }
        
        return data._string(using: encoding)
    }
    
    /// [刪除Keychain => <key>._removeKeychain()](https://cloud.tencent.com/developer/article/1858204)
    /// - Returns: Bool
    func _removeKeychain() -> Bool {
        
        let query = [kSecAttrAccount: self, kSecClass: kSecClassGenericPassword] as [CFString : Any] as CFDictionary
        let status = SecItemDelete(query)
        
        return (status == errSecSuccess)
    }
}

// MARK: - String (private function)
private extension String {
    
    /// [SecItemUpdate(_:_:)](https://developer.apple.com/documentation/security/1393617-secitemupdate)
    /// - Parameters:
    ///   - query: [CFString : Any]
    ///   - fields: [CFString : Any]
    /// - Returns: OSStatus
    func _SecItemUpdate(query: [CFString : Any], fields: [CFString : Any]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, fields as CFDictionary)
    }
    
    /// [SecItemAdd(_:_:)](https://developer.apple.com/documentation/security/1401659-secitemadd)
    /// - Parameters:
    ///   - query: [CFString : Any]
    ///   - result: UnsafeMutablePointer<CFTypeRef?>?
    /// - Returns: OSStatus
    func _SecItemAdd(query: [CFString : Any], result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        return SecItemAdd(query as CFDictionary, result)
    }
    
    /// [SecItemCopyMatching(_:_:)](https://developer.apple.com/documentation/security/1398306-secitemcopymatching)
    /// - Parameters:
    ///   - query: [CFString : Any]
    ///   - result: UnsafeMutablePointer<CFTypeRef?>?
    /// - Returns: OSStatus
    func _SecItemCopyMatching(query: [CFString : Any], result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        return SecItemCopyMatching(query as CFDictionary, result)
    }
}
