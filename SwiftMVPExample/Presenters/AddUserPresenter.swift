//
//  AddUserPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/20.
//

import Foundation

protocol AddUserPresenterInput {
    func addUser(userId: String, name: String, comment: String)
}

protocol AddUserPresenterOutput: AnyObject {
    func didSuccessAddUserApi()
    func addUserApiFailed()
}

class AddUserPresenter: AddUserPresenterInput {
 
    private weak var view: AddUserPresenterOutput?
    
    private var dataModel: UserDataModelInput
    
    init(with view: AddUserPresenterOutput) {
        self.view = view
        self.dataModel = UserDataModel()
    }
    
    func addUser(userId: String, name: String, comment: String) {
        dataModel.addUser(userId: userId, name: name, comment: comment) { (success, error) in
            guard success else {
                self.view?.addUserApiFailed()
                return
            }
            self.view?.didSuccessAddUserApi()
        }
    }
}
