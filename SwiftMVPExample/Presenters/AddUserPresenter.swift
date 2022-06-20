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
    
    init(with view: AddUserPresenterOutput) {
        self.view = view
    }
    
    func addUser(userId: String, name: String, comment: String) {
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
                self.view?.didSuccessAddUserApi()
            } catch ApiManager.ApiError.httpError(let error) {
                IndicatorView.shared.stopIndicator()
                print("\(error.statusCode) : \(error.message)")
                self.view?.addUserApiFailed()
            } catch {
                IndicatorView.shared.stopIndicator()
                print(error.localizedDescription)
                self.view?.addUserApiFailed()
            }
        }
    }
    
}
