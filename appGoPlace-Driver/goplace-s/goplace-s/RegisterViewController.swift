//
//  RegisterViewController.swift
//  goplace-s
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBAction func userRegister(_ sender: Any) {
        
        let error = validarFormulario()
               
               if error != nil {
                   self.error(_error: error!)
               } else {
                   let name = userNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   let phone = phoneTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   
                   FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                                       
                                   if err != nil{
                                       
                                       self.error(_error: err!.localizedDescription)
                                   }else{
                    
                                       let db = Firestore.firestore()
                            
                                       db.collection("drivers").addDocument(data: [
                                               "name" : name,
                                               "email" : email,
                                               "password" : password,
                                           "phone": phone,
                                               "uid": result!.user.uid
                                       ]){ (error) in
                                           
                                           if error != nil{
                                               
                                               self.error(_error: "Sucedio un error.")
                                           }
                                       }
                                       self.navigationController?.popToRootViewController(animated: true)
                                   }
                               }
               }
    }
    
    func error(_error: String) {
                let alertController = UIAlertController(title: "Register error", message: _error, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
    
    func validarFormulario() -> String? {
         
            if userNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || phoneTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""            {

                return "Es necesario rellenar todos los campos"
            }

            return nil
        }
    
    @IBOutlet weak var anchorBottomScroll:  NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registrerKeyboardEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction private func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }


    private func registrerKeyboardEvents() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func unregisterKeyboardEvents() {

        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {

        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0

        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = -keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {

        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0

        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = 0
            self.view.layoutIfNeeded()
        }
    }}
