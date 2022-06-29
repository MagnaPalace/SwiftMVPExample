//
//  AddUserPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/20.
//

import Foundation

protocol AddUserPresenterInput {
    func addUserButtonTapped(userId: String, name: String, comment: String)
}

protocol AddUserPresenterOutput: AnyObject {
    func returnToUserListView()
    func showAddUserApiFailedAlert()
    func startIndicator()
    func stopIndicator()
    func showNotCompletedInputFieldAlert()
}

class AddUserPresenter: AddUserPresenterInput {
 
    private weak var view: AddUserPresenterOutput?
    
    private var dataModel: UserDataModelInput
    
    init(with view: AddUserPresenterOutput) {
        self.view = view
        self.dataModel = UserDataModel()
    }
    
    func addUserButtonTapped(userId: String, name: String, comment: String) {
        guard userId.count > 0, name.count > 0, comment.count > 0 else {
            self.view?.showNotCompletedInputFieldAlert()
            return
        }
        self.view?.startIndicator()
        dataModel.addUser(userId: userId, name: name, comment: comment) { (error) in
            self.view?.stopIndicator()
            guard error == nil else {
                self.view?.showAddUserApiFailedAlert()
                return
            }
            self.view?.returnToUserListView()
        }
    }
}
