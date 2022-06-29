//
//  AddUserViewController.swift
//  SwiftAsyncExample
//
//  Created by Takeshi Kayahashi on 2022/05/23.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var commentTextField: UITextField!

    weak var delegate: AddUserViewControllerDelegate?
    
    private var presenter: AddUserPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = String.Localize.addUserViewTitle.text
        
        userIdTextField.delegate = self
        nameTextField.delegate = self
        commentTextField.delegate = self
        
        self.presenter = AddUserPresenter.init(with: self)
        
        self.setNumberKeyboardDoneButton()
    }

    @IBAction func addUserButtonTapped(_ sender: Any) {
        self.presenter.addUserButtonTapped(userId: userIdTextField.text, name: nameTextField.text, comment: commentTextField.text)
    }
    
    /// ナンバーキーボードに完了ボタン追加
    private func setNumberKeyboardDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped(_:)))
        toolBar.items = [spacer, doneButton]
        userIdTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        userIdTextField.resignFirstResponder()
    }
    
    private func storeUserApiFailedAlert() {
        let alert = UIAlertController(title: String.Localize.errorAlertTitle.text, message: String.Localize.networkCommunicationFailedMessage.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addUserFailedAlert() {
        let alert = UIAlertController(title: String.Localize.errorAlertTitle.text, message: String.Localize.addUserFailedMessage.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func notCompletedInputFieldAlert() {
        let alert = UIAlertController(title: String.Localize.confirmAlertTitle.text, message: String.Localize.notCompletedInputFieldMessage.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}

extension AddUserViewController: AddUserPresenterOutput {
    
    func returnToUserListView() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
        self.delegate?.didEndAddUser()
    }
    
    func showAddUserApiFailedAlert() {
        DispatchQueue.main.async{
            self.addUserFailedAlert()
        }
    }
    
    func startIndicator() {
        IndicatorView.shared.startIndicator()
    }
    
    func stopIndicator() {
        IndicatorView.shared.stopIndicator()
    }
    
    func showNotCompletedInputFieldAlert() {
        DispatchQueue.main.async{
            self.notCompletedInputFieldAlert()
        }
    }
    
}

protocol AddUserViewControllerDelegate: AnyObject {
    func didEndAddUser()
}
