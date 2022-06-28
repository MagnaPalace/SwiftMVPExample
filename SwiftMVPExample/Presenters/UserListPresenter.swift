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
    func addBarButtonTapped()
}

protocol UserListPresenterOutput: AnyObject {
    func reloadTableView()
    func showFetchUsersApiFailedAlert()
    func startIndicator()
    func stopIndicator()
    func transitionToAddUserView()
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
        self.view?.startIndicator()
        dataModel.fetchUsers() { (users, error) in
            self.view?.stopIndicator()
            guard error == nil else {
                self.view?.showFetchUsersApiFailedAlert()
                return
            }
            self.users = users
            self.view?.reloadTableView()
        }
    }
    
    func usersCount() -> Int {
        return self.users.count
    }
        
    func getUser(row: Int) -> User {
        return self.users[row]
    }
    
    func addBarButtonTapped() {
        self.view?.transitionToAddUserView()
    }
    
}
