//
//  UserService.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import Foundation
// user資訊
class User {
    var mid = ""
    var member_id = ""
    var member_pwd = ""
    var member_name = ""
    // ??
    func setup(with dict: [String: Any]) {
        let temp = dict.castToDictionary()
        self.mid = temp["mid"] ?? ""
        self.member_id = temp["member_id"] ?? ""
        self.member_pwd = temp["member_pwd"] ?? ""
        self.member_name = temp["member_name"] ?? ""
    }
}

class UserService {
    static let shared = UserService()
    // 變成唯讀狀態，只能get，不能set，set狀態不能比get高(這裏get沒定義就是internal)
    private(set) var user: User?
    var renewUser: (() -> ())?
    
    private init() {
        guard let account = UserDefaults.standard.string(forKey: "account"), account != "",
              let password = UserDefaults.standard.string(forKey: "password"), password != "" else { return }
        logIn(account: account, password: password, completion: {_, _ in})
    }
    
    func logIn(account: String, password: String, completion: @escaping (Bool, String) -> ()) {
        guard account != "", password != "" else {
            completion(false, "帳密不可空白")
            return
        }
        // API request需要url/parameter
        let url = API_URL + URL_USERLOGIN
        let parameter = "member_id=\(account)&member_pwd=\(password)"
        WebAPI.shared.request(urlString: url, parameters: parameter) { isSuccess, data, error in
            if error != nil && !isSuccess {
                print(error)
            }
            if isSuccess {
                UserDefaults.standard.set(account, forKey: "account")
                UserDefaults.standard.set(password, forKey: "password")
                self.loadUser(account: account, password: password)
            }
            var errorMessage = error?.localizedDescription ?? ""
            if let data = data,
               let results = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
               let msg = results["responseMessage"] as? String {
                errorMessage = msg
                if msg == "ID or password is wrong!" {
                    errorMessage = "帳號或密碼錯誤"
                }
            }
            completion(isSuccess, errorMessage)
        }
    }
    
    private func loadUser(account: String, password: String) {
        let url = API_URL + URL_MEMBERINFO
        let parameter = "member_id=\(account)&member_pwd=\(password)"
        WebAPI.shared.request(urlString: url, parameters: parameter) { isSuccess, data, error in
            guard isSuccess,
                  let data = data,
                  let results = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                  let result = results.first else { return }
            let user = User()
            user.setup(with: result)
            self.user = user
            self.renewUser?()
        }
    }
    
    func signUp(_ newUser: User, completion: @escaping (Bool, String) -> ()) {
        guard newUser.member_id != "",
              newUser.member_pwd != "",
            newUser.member_name != "" else { return }
        let url = API_URL + URL_USERREGISTER
        let parameter = "member_id=\(newUser.member_id)&member_pwd=\(newUser.member_pwd)&member_name=\(newUser.member_name)&member_type=1"
        WebAPI.shared.request(urlString: url, parameters: parameter) { isSuccess, data, error in
            if error != nil || !isSuccess {
                print(error)
            }
            var errorMsg = ""
            if let data = data,
               let results = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
               let msg = results["responseMessage"] as? String {
                errorMsg = msg
            }
            if isSuccess {
                self.loadUser(account: newUser.member_id, password: newUser.member_pwd)
            }
            completion(isSuccess, errorMsg)
        }
    }
    
    func logout() {
        user = nil
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "password")
        
        UserDefaults.standard.removeObject(forKey: "gotArSpot")
        UserDefaults.standard.removeObject(forKey: "dotArDate")
    }
    
    func getCoupon(id: String, completion: ((Coupon)->())?) {
        guard let user = UserService.shared.user else{ return }
        let url = API_URL + URL_GETCOUPON
        let parameters = "member_id=\(user.member_id)&member_pwd=\(user.member_pwd)&coupon_id=\(id)"
        WebAPI.shared.request(urlString: url, parameters: parameters) { isSuccess, data, error in
            if let data = data {
                print(String(data: data, encoding: .utf8))
            }
//            coupon_info以String的形式解析
            guard isSuccess, let data = data, let results = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let couponinfo = results["coupon_info"] as? String, let infoData = couponinfo.data(using: .utf8), let infos = try? JSONSerialization.jsonObject(with: infoData, options: []) as? [[String: Any]], let info = infos.first else{return}
            completion?(Coupon(with: info))
        }
    }
    
    func loadCoupon(completion: (([[String: Any]])->())?) {
        guard let user = user else{ return }
        let url = API_URL + URL_MYCOUPONLIST
        let parameters: [String: Any] = ["member_id": user.member_id, "member_pwd": user.member_pwd]
        WebAPI.shared.request(urlString: url, parameters: parameters) { isSuccess, data, error in
            guard isSuccess,
                  let data = data,
                  let results = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            completion?(results)
        }
    }
}
