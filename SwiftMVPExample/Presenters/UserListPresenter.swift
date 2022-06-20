//
//  UserListPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/05.
//

import Foundation

protocol UserListPresenterInput {
    func viewDidLoad()
    func usersCount() -> Int
    func users(row: Int) -> User
}

protocol UserListPresenterOutput: AnyObject {
    func didFetch()
    func getUsersApiFailed()
}

class UserListPresenter: UserListPresenterInput {
    
    private(set) var users: [User] = []
    
    private weak var view: UserListPresenterOutput?
    
    init(with view: UserListPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchUsers()
    }
    
    /// ユーザーの全取得
    func fetchUsers() {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.all.rawValue)!
        IndicatorView.shared.startIndicator()
        
        // Swift 5.5 Concurrency async/await
        Task {
            do {
                let result = try await api.requestAsync(param: nil, url: url)
                guard let json = (result as AnyObject)["users"] as? [User.Json], json.count > 0 else {
                    IndicatorView.shared.stopIndicator()
                    return
                }
                IndicatorView.shared.stopIndicator()
                self.users = json.map { User.fromJson(user: $0) }
                self.view?.didFetch()
            } catch ApiManager.ApiError.httpError(let error) {
                IndicatorView.shared.stopIndicator()
                print("\(error.statusCode) : \(error.message)")
                self.view?.getUsersApiFailed()
            } catch {
                IndicatorView.shared.stopIndicator()
                print(error.localizedDescription)
                self.view?.getUsersApiFailed()
            }
        }
    }
    
    func usersCount() -> Int {
        return self.users.count
    }
        
    func users(row: Int) -> User {
        return self.users[row]
    }
    
}
