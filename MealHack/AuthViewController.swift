//
//  AuthViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 19/5/21.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        guard let password = passwordTextField.text else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }
        
        guard let email = emailTextField.text else {
            displayMessage(title: "Error", message: "Please enter an email")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
         (user, error) in
            if let error = error {
             self.displayMessage(title: "Error", message:
             error.localizedDescription)
            }
        }
    }
    @IBAction func signupButton(_ sender: Any) {
        guard let password = passwordTextField.text else {
         displayMessage(title: "Error", message: "Please enter a password")
         return
        }

        guard let email = emailTextField.text else {
         displayMessage(title: "Error", message: "Please enter an email")
         return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
         (user, error) in
            if let error = error {
             self.displayMessage(title: "Error", message:
             error.localizedDescription)
            }
        }
    }
    
    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        authHandle = Auth.auth().addStateDidChangeListener() {
            (auth, user) in
            guard user != nil else { return }
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
}
