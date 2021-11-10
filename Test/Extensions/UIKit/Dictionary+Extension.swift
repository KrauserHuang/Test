//
//  Dictionary+Extension.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import Foundation

extension Dictionary {
    // 轉成[String: String]格式，非String值跳過
    func castToDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        // 從自己取出每一項的key
        for k in self.keys {
            if let key = k as? String,
               let value = self[k] as? String {
                dict.updateValue(value, forKey: key)
            }
        }
        return dict
    }
    
//    func convertToDictionary() -> [String: Any] {
//        if let data = self.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print("ConvertToDictionary() \(error.localizedDescription)")
//            }
//        }
//        return nil
//    }
}
