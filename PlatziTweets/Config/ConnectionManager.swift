//
//  ConnectionManager.swift
//  PlatziTweets
//
//  Created by mac1 on 10/04/21.
//  Copyright © 2021 mac1. All rights reserved.
//

import UIKit



class ConnectionManager {
    
    static let sharedInstance = ConnectionManager()
    private var reachability : ReachabilityManager!
    let def = UserDefaults.standard

    func observeReachability(){
        do {
            //Se da de alta el observable para el cambio de señal
            self.reachability = try ReachabilityManager()
            NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
            print("02 inicia el starnotifier")
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! ReachabilityManager
        switch reachability.connection {
        case .cellular,.wifi:
            print("Network available via WiFi.")
            verifyRegister()
            verifyUpdate()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "updateIconSync")))
            break
        case .none:
            print("Network is not available.")
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "updateIconSync")))
            break
        case .unavailable:
            print("02 Network is  unavailable.")
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "updateIconSync")))
            break
        }
    }
    
    func verifyRegister() {
   /*     let json = def.string(forKey: Constants.lastRegister)
        if let jsonRegister = json {
            if !jsonRegister.isEmpty {
                sendRegister(jsonRegister: jsonRegister)
            }
        }*/
    }
    
    func verifyUpdate() {
       /* let json = def.string(forKey: Constants.lastUpdate)
        if let jsonUpdate = json {
            if !jsonUpdate.isEmpty {
                sendUpdate(jsonUpdate: jsonUpdate)
            }
        }*/
    }
    
    func sendRegister(jsonRegister: String) {
     /*   do {
            let jsonDecoder = JSONDecoder()
            let usuario = try jsonDecoder.decode(UsuarioMovil.self, from: jsonRegister.data(using: .utf8)!)
            VacunAccionAPI.registerOffline(usuarioMovil: usuario) { (result)  in
                if result == true {
                    VacunAccionAPI.getUserInfo(email: usuario.usuario.correo){ (result, object) in
                        if result {
                            var profiles = object?.usuarioMovil.perfiles ?? []
                            profiles = profiles.compactMap({
                                $0.idPerfil != 1 ? $0 : nil
                            })
                            var rol: Rol = .unknown
                            if profiles.count == 1 {
                                rol = Rol(rawValue: profiles.first?.idPerfil ?? 0) ?? .unknown
                            }
                            guard let usuarioMovil = object?.usuarioMovil else {
                                return
                            }
                            AccountInfoSession.shared.persistUser(usuarioMovil, rol: rol)
                                    VacunAccionDB.updateUserInfoLocal(email: usuario.usuario.correo, user: usuarioMovil, oldid: usuario.consultorio?.idConsultorio, oldidUser: usuario.usuario.id ?? "") { (result) in
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "editProfileSuccess"), object: nil)
                                self.def.removeObject(forKey: Constants.lastRegister)
                                self.def.synchronize()
                            }
                        }
                    }
                }else{
                    print("Error al subir el registro local")
                }
            }
        } catch  {
            debugPrint(error)
            print("Error al subir el registro local")
        }*/
    }
    
    func sendUpdate(jsonUpdate: String) {
    /*    if let correo = def.string(forKey: Constants.lastEmail) {
            VacunAccionAPI.updateOffline(usuario: jsonUpdate, correo: correo) { (result)  in
                if result == true {
                    self.def.removeObject(forKey: Constants.lastUpdate)
                    self.def.removeObject(forKey: Constants.lastEmail)
                    self.def.synchronize()
                }else{
                    print("Error al subir la actualización local")
                }
            }
        }*/
    }
}


