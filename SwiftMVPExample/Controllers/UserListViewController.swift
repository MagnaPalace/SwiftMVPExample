//
//  UserListViewController.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/05.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var presenter: UserListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SwiftMVPExample"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.presenter = UserListPresenter.init(with: self)
        self.presenter.viewDidLoad()
        
        self.setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        self.presenter.addBarButtonTapped()
    }

}

extension UserListViewController: UserListPresenterOutput {
    
    func reloadTableView() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func showFetchUsersApiFailedAlert() {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: String.Localize.errorAlertTitle.text, message: String.Localize.networkCommunicationFailedMessage.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startIndicator() {
        IndicatorView.shared.startIndicator()
    }
    
    func stopIndicator() {
        IndicatorView.shared.stopIndicator()
    }
    
    func transitionToAddUserView() {
        let storyboard = UIStoryboard(name: "AddUserViewController", bundle: nil)
        let addUserViewController = storyboard.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        addUserViewController.delegate = self
        self.navigationController?.pushViewController(addUserViewController, animated: true)
    }
    
}

extension UserListViewController: UITableViewDelegate {
    
}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.presenter.getUser(row: indexPath.row)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell") as? UserListTableViewCell
        cell?.initialize(model: .init(userNo: user.userId, name: user.name, comment: user.comment))
        return cell!
    }
    
}

extension UserListViewController: AddUserViewControllerDelegate {

    func didEndAddUser() {
        self.presenter.viewDidLoad()
    }

}
