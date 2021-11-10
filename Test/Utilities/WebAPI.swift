//
//  WebAPI.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import Foundation
import CryptoKit
import UIKit

class WebAPI: NSObject {
    static let shared = WebAPI()
    private override init(){}
    let HttpSecretToken = ""
    /**
     parameters = [參數1名稱:參數1內容, 參數2名稱:參數2內容, ...]
     */
    func request(urlString: String, parameters: [String: Any], method: String = "POST", useMd5: Bool = false, completion: @escaping(_ status: Bool, _ data: Data?, _ error: Error?) -> ()) {
        var paraString = ""
        for parameter in parameters {
            if paraString != "" {
                paraString += "&"
            }
            paraString += "\(parameter.key)=\(parameter.value)"
        }
        self.request(urlString: urlString, parameters: paraString, completion: completion)
    }
    /**
    parameters = "參數1名稱=參數1內容&參數2名稱=參數2內容..."
     */
    func request(urlString: String, parameters: String, method: String = "POST", useMd5: Bool = false, completion: @escaping(_ status: Bool, _ data: Data?, _ error: Error?) -> ()) {
        var urlStr = urlString
        if method == "GET", parameters != "" {
            urlStr += "?" + parameters
        }
        guard let url = URL(string: urlStr) else {
            print("urlError: \(urlString)")
            DispatchQueue.main.async {
                completion(false, nil, nil)
            }
            return
        }
        var request = URLRequest(url: url)
        if method == "POST" {
            request.httpMethod = "POST"
            request.httpBody = parameters.data(using: .utf8)
        }
//        if useMd5 {
//            if #available(iOS 13.0, *) {
//                let dateformat = DateFormatter()
//                dateformat.dateFormat = "yyyyMMdd"
//                let headString = HttpSecretToken + dateformat.string(from: Date())
//                let md5 = Insecure.MD5.hash(data: headString.data(using: .utf8)!)
//                let md5Str = md5.map({ String(format: "%02hhx", $0) }).joined()
//                request.addValue(md5Str, forHTTPHeaderField: "Authorization")
//            }
//        }
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                print("###url: \(url)\n###errorCode: \(error.code)\n###description: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                // 取消所有session包含task
                session.invalidateAndCancel()
                return
            }
            guard error == nil else {
                print("##url: \(url)\n##error: \(error)")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
            // 確認網路回傳狀態是否成功
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("###url: \(url)\n###responseError: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
            // 確認回傳的JSON status是不是false
            if let data = data,
               let results = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], results["status"] as? String == "false" {
                print("##url: \(url)\n##errorData: \(String(describing: data))\n##\(results)")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
            DispatchQueue.main.async {
                completion(true, data, error)
            }
            session.invalidateAndCancel()
        }.resume()
    }
    
    func requestImage(urlString: String, completion: @escaping ((UIImage) -> ())) {
        guard let picUrl = URL(string: urlString) else {
            print("url: \(urlString)")
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: picUrl) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data,
            let image = UIImage(data: data) else {
                print("dataError")
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
