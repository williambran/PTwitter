//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var namesTextField: UITextField!

    
    
    //MARK: - IBActions
    @IBAction func registerButtonAction(){
        view.endEditing(true)
        performRegister()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        registerButton.layer.cornerRadius = 25
    }

    
    private func performRegister(){
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes de especificar un correo", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else{
                        NotificationBanner(title: "Error", subtitle: "Debes de especificar una contraseña", style: .warning).show()
            return
        }
        
        guard let name = namesTextField.text, !name.isEmpty else{
                        NotificationBanner(title: "Error", subtitle: "Debes de especificar un nombre y apellido", style: .warning).show()
            return
        }
        
        
        //Crear Request
        let request = RegisterRequest(email: email, password: password, names: name)
        
        //Indicar la carga a usuario
        SVProgressHUD.show()
        
        //LLamar al servicio
        SN.post(endpoint: Endpoints.register, model: request) { (response: SNResultWithEntity<LoginResponse , ErrorResponse>) in
            
        // Cerramos la carga
            SVProgressHUD.dismiss()
            
            switch response {
                
            case .success(let user):
                NotificationBanner(title: "Bienvenido ", subtitle:"", style: .success).show()
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
            case .error(let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .danger).show()
                
            }
            
        }
      //  performSegue(withIdentifier: "showHome", sender: nil)

        //registrarnos
    }

}
