//
//  UserDataModel.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/22.
//

import Foundation

protocol UserDataModelInput {
    func fetchUsers(completion: @escaping (_ success: Bool, _ result: [User], _ error: NSError?) -> ())
    func addUser(userId: String, name: String, comment: String, completion: @escaping (_ success: Bool, _ error: NSError?) -> ())
}

class UserDataModel: UserDataModelInput {
    
    /// ユーザーの全取得
    func fetchUsers(completion: @escaping (_ success: Bool, _ result: [User], _ error: NSError?) -> ()) {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.all.rawValue)!
        IndicatorView.shared.startIndicator()
        
        // Swift 5.5 Concurrency async/await
        Task {
            do {
                let result = try await api.requestAsync(param: nil, url: url)
                guard let json = (result as AnyObject)["users"] as? [User.Json], json.count > 0 else {
                    IndicatorView.shared.stopIndicator()
                    completion(false, [], nil)
                    return
                }
                IndicatorView.shared.stopIndicator()
                let users = json.map { User.fromJson(user: $0) }
                completion(true, users, nil)
            } catch ApiManager.ApiError.httpError(let error) {
                IndicatorView.shared.stopIndicator()
                print("\(error.statusCode) : \(error.message)")
                completion(false, [], error as NSError)
            } catch {
                IndicatorView.shared.stopIndicator()
                print(error.localizedDescription)
                completion(false, [], error as NSError)
            }
        }
    }
    
    /// ユーザーの追加
    func addUser(userId: String, name: String, comment: String, completion: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.store.rawValue)!
        
        let parameter = [
            User.Key.userId.rawValue: userId,
            User.Key.name.rawValue: name,
            User.Key.comment.rawValue: comment,
        ]

        IndicatorView.shared.startIndicator()

        // Swift 5.5 Concurrency async/await
        Task {
            do {
                let result = try await api.requestAsync(param: parameter as [String : Any], url: url)
                print(result)
                IndicatorView.shared.stopIndicator()
                completion(true, nil)
            } catch ApiManager.ApiError.httpError(let error) {
                IndicatorView.shared.stopIndicator()
                print("\(error.statusCode) : \(error.message)")
                completion(false, error as NSError)
            } catch {
                IndicatorView.shared.stopIndicator()
                print(error.localizedDescription)
                completion(false, error as NSError)
            }
        }
    }
    
}
