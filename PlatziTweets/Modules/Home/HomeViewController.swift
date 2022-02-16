//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 15/09/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // getPosts()
    }
    
    func setupUI(){
        // 1. Asignar datasource
        // 2. registrar celda
        tableView?.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = UITableView.automaticDimension
    }
    
     func getPosts(){
        // 1. Asignar dtasource
        SVProgressHUD.show()
        
        // 2. Registrar celda  Los valores del resultados , se definen aqui, y usa el segundo get
        SN.get(endpoint: Endpoints.getPosts) { (response:SNResultWithEntity<[Post], ErrorResponse>) in
            SVProgressHUD.dismiss()
                       
                       switch response {
                       case .success(let posts):
                        self.dataSource =  posts
                           print("response wito",posts)
                           NotificationBanner(title: "succes", subtitle: "sucedio bien. Bienvenido ", style: .success).show()
                        self.tableView.reloadData()
                       case .error(let error):
                           print("error wito",error)
                            NotificationBanner(title: "Error", subtitle: "Algo salio mal", style: .danger).show()
                       case .errorResult(let entity):
                           print("error con resultado", entity)
                            NotificationBanner(title: "error", subtitle: "\(entity)", style: .warning).show()
                       }
            
        }
        
    }
    
    private func delatePostAt(indextPath: IndexPath) {
        //1. indicar carga del usuario
        SVProgressHUD.show()
        
        //2. Obtener id del post que vamos a borrar
        let postId = dataSource[indextPath.row].id
        
        //3. preparamos el endpoint para borrar
        let endPoint = Endpoints.delete + postId
        
        //4. Consumir servicio ppara borrar
        SN.delete(endpoint: endPoint) { (response: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
                        SVProgressHUD.dismiss()
                       
                       switch response {
                       case .success:
                        //1. Borrar el post del datasource
                        self.dataSource.remove(at: indextPath.row)
                        //2. Borrar la celda de la tabla
                        self.tableView.deleteRows(at: [indextPath], with: UITableView.RowAnimation.fade)
                        
                        self.tableView.reloadData()
                       case .error(let error):
                           print("error wito",error)
                            NotificationBanner(title: "Error", subtitle: "Algo salio mal", style: .danger).show()
                       case .errorResult(let entity):
                           print("error con resultado", entity)
                            NotificationBanner(title: "error", subtitle: "\(entity)", style: .warning).show()
                       }
        }
    }
    
    // MARK: - Navigation
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            self.delatePostAt(indextPath: indexPath)
            
        }
        return [deleteAction]
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            cell.setUpCellWith(post: dataSource[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource[indexPath.row].hasVideo && dataSource[indexPath.row].videoUrl != nil && !dataSource[indexPath.row].videoUrl.isEmpty {
        let prueba =  dataSource[indexPath.row]
            
        let avPlayer = AVPlayer(url:URL(string: prueba.videoUrl)! )            // este es el AVPlayer
        
        let avPlayerController =  AVPlayerViewController()        //este es el que levanta la vista para reproducir el video
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true){
            avPlayerController.player?.play()
        }
    }
    }
    
}

extension HomeViewController {
     // se ejecuta cucunado vamos de una pantalla a otra (solo con storyboards)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //para saber si vamos al mapa
        if segue.identifier == "showMap", let  mapViewController = segue.destination as? MapViewViewController {
            mapViewController.post = dataSource.filter{$0.hasLocation}
        }
    }
}
