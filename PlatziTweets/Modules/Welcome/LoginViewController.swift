//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

@available(iOS 13.0, *)
class LoginViewController: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var networtIcon: UIImageView!
    
    
    //MARK: - IBActions
    @IBAction func loginButtonAction(){
        view.endEditing(true)
        performLogin()
        var palabra = "ejemplo_de_string".localizable()
       palabra = palabra.removeCharacters(from: "*")
        palabra = palabra.removeCharacters(from: "o")
        print("ejemplo de localizable", palabra)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
       // setupObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObserver()
        
    }
    

    //MARK: - Private Methods
    private func setupUI(){
        loginButton.layer.cornerRadius = 25
    }
    
    private func setupObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateIconSync), name: Notification.Name("updateIconSync"), object: nil)
        
        updateIconSync()
    }
    
    
    private func performLogin(){
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes de especificar un correo", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else{
                        NotificationBanner(title: "Error", subtitle: "Debes de especificar una contraseña", style: .warning).show()
            return
        }
        
        //Crear reuqest
        let request = LoginRequest(email: email, password: password)
        
        // inicimaos carga con spinner
        SVProgressHUD.show()
        //llamar a libreria
        SN.post(endpoint: Endpoints.login, model: request) {  ( response: SNResultWithEntity<LoginResponse , ErrorResponse>) in
           
            SVProgressHUD.dismiss()
            
            switch response {
            case .success(let user):
                print("response wito",response)
                NotificationBanner(title: "succes", subtitle: "sucedio bien. Bienvenido \(user.user.names)", style: .success).show()
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
            case .error(let error):
                print("error wito",error)
                 NotificationBanner(title: "Error", subtitle: "Algo salio mal", style: .danger).show()
            case .errorResult(let entity):
                print("error con resultado", entity)
                 NotificationBanner(title: "error", subtitle: "\(entity)", style: .warning).show()
            }
        }
      //  performSegue(withIdentifier: "showHome", sender: nil)
        //Iniciar sesion
    }
    
   // @available(iOS 13.0, *)
    @objc func updateIconSync(){
        
        DispatchQueue.main.async {
             NetworkConnectionHelper().checkNetwork(){(coneccion)  in
                let lss = coneccion!
                
                if lss {
                    self.networtIcon.image = UIImage(systemName: "wifi")?.withRenderingMode(.alwaysOriginal)
                } else {
                    self.networtIcon.image = UIImage(systemName: "wifi.slash")?.withRenderingMode(.alwaysOriginal)
                    // Fallback on earlier versions
                }
            }
        }
    }
    
}
