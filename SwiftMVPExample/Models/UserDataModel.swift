//
//  UserDataModel.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/22.
//

import Foundation

protocol UserDataModelInput {
    func fetchUsers(completion: @escaping (_ result: [User], _ error: ApiManager.ApiError?) -> ())
    func addUser(userId: String, name: String, comment: String, completion: @escaping (_ error: ApiManager.ApiError?) -> ())
}

class UserDataModel: UserDataModelInput {
    
    /// ユーザーの全取得
    /// - Parameter completion: 結果 / エラー
    func fetchUsers(completion: @escaping (_ result: [User], _ error: ApiManager.ApiError?) -> ()) {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.all.rawValue)!
        
        // Swift 5.5 Concurrency async/await
        Task {
            do {
                let result = try await api.requestAsync(param: nil, url: url)
                guard let json = (result as AnyObject)["users"] as? [User.Json], json.count > 0 else {
                    completion([], .noResponse)
                    return
                }
                let users = json.map { User.fromJson(user: $0) }
                completion(users, .none)
            } catch ApiManager.ApiError.httpError(let error) {
                print("\(error.statusCode) : \(error.message)")
                completion([], .httpError(error))
            } catch {
                print(error.localizedDescription)
                completion([], .other(error))
            }
        }
    }
    
    
    /// ユーザーの追加
    /// - Parameters:
    ///   - userId: ユーザーID
    ///   - name: 名前
    ///   - comment: コメント
    ///   - completion: エラー
    func addUser(userId: String, name: String, comment: String, completion: @escaping (_ error: ApiManager.ApiError?) -> ()) {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.store.rawValue)!
        
        let parameter = [
            User.Key.userId.rawValue: userId,
            User.Key.name.rawValue: name,
            User.Key.comment.rawValue: comment,
        ]

        // Swift 5.5 Concurrency async/await
        Task {
            do {
                let result = try await api.requestAsync(param: parameter as [String : Any], url: url)
                print(result)
                completion(.none)
            } catch ApiManager.ApiError.httpError(let error) {
                print("\(error.statusCode) : \(error.message)")
                completion(.httpError(error))
            } catch {
                print(error.localizedDescription)
                completion(.other(error))
            }
        }
    }
    
}
