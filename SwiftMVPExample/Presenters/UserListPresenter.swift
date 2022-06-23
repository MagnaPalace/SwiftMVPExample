//
//  UserListPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/05.
//

import Foundation
import UIKit

protocol UserListPresenterInput {
    func viewDidLoad()
    func usersCount() -> Int
    func getUser(row: Int) -> User
}

protocol UserListPresenterOutput: AnyObject {
    func didFetch()
    func getUsersApiFailed()
}

class UserListPresenter: UserListPresenterInput {
    
    private weak var view: UserListPresenterOutput?
    
    private var dataModel: UserDataModelInput
    
    private(set) var users: [User] = []
    
    init(with view: UserListPresenterOutput) {
        self.view = view
        self.dataModel = UserDataModel()
    }
    
    func viewDidLoad() {
        IndicatorView.shared.startIndicator()
        dataModel.fetchUsers() { (users, error) in
            IndicatorView.shared.stopIndicator()
            guard error == nil else {
                self.view?.getUsersApiFailed()
                return
            }
            self.users = users
            self.view?.didFetch()
        }
    }
    
    func usersCount() -> Int {
        return self.users.count
    }
        
    func getUser(row: Int) -> User {
        return self.users[row]
    }
    
}
