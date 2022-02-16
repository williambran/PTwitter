//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 17/09/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import  NotificationBannerSwift
import FirebaseStorage
import AVFoundation        //de aqui pa bajo nos sirven para trabajar con el audio
import AVKit
import MobileCoreServices
import CoreLocation

class AddPostViewController: UIViewController {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        videoButton.isHidden = true
        requestLocation()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPostAction() {
    //    uploadPhotoToFirebase()
    //    openVideoCamara()
        
        if currentVideoURL != nil {
            uploadVideoToFirebase()
            return
        }
        if previewImageView.image != nil {
            uploadPhotoToFirebase()
            return
        }
        
        savePost(imageUrl: nil, videoUrl: nil)
        
    }
    
    @IBAction func openPreviewAction() {
        guard let currentVideoURL = currentVideoURL else {
            return
        }
        
        let avPlayer = AVPlayer(url: currentVideoURL)            // este es el AVPlayer
        
        let avPlayerController =  AVPlayerViewController()        //este es el que levanta la vista para reproducir el video
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true){
            avPlayerController.player?.play()
        }
    }
    @IBAction func openCamaraAction() {
        //  openCamara()
        //   openGaleria()
        //  openVideoCamara()
        let alert = UIAlertController(title: "Camara", message: "Seleccione un opcion", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { _ in
            self.openCamara()
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openVideoCamara()
        }))
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { _ in
            self.openGaleria()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dissmisAction() {
       // dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
    private var imagePicker: UIImagePickerController?
    private var currentVideoURL: URL?    //importnate para poderlo guardar y poder mandarlo a firebase
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    
    

    
    private func openCamara() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func requestLocation() {
        //validamos que el usuario tenga sus permisos activados y el gps activo
        guard CLLocationManager.locationServicesEnabled() else {
            NotificationBanner(title: "Pedir permisos", subtitle: "Para publicar con localizacion ",  style: .warning).show()
            return
        }
        print("pedi permisos")
        locationManager = CLLocationManager()
        locationManager?.delegate  = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func openVideoCamara() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .typeMedium
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openGaleria() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .photoLibrary
       // imagePicker?.cameraFlashMode = .off
       // imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        self.view.endEditing(true)
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadPhotoToFirebase(){
        //1. Asegurarse que existe la foto
        //2. Convertir la foto a Data y le bajamos la calidad
        guard let imageSave = previewImageView.image,
            let imageSaveDate: Data = imageSave.jpegData(compressionQuality: 1.0) else{
                return
        }
        SVProgressHUD.show()
        
        //3. Configuracion para guardar la foto en firebase
         let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"   //para que entienda que le vamos a poner el stroage

        //4. Referencia al storage de firebase
        let storage = Storage.storage()
        
        //5. crear nombre de la image
        let imageName = Int.random(in: 100...1000)
        
        //6. Referencia a donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "fotos-tweets/\(imageName).jpg")  //la ruta
        
        //7. Subir la foto a firebase
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            folderReference.putData(imageSaveDate, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription,  style: .warning).show()
                        return
                    }
                    //Obtener la URL de descarga
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        print("prueba storage",url )
                        let dowloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: dowloadUrl, videoUrl: nil)
                    }
                }
            }
        }
    }
    
    
    
    private func uploadVideoToFirebase(){
        //1. Asegurarse que existe el video
        //2. Convertir el video a Data
        guard let currentVideoURL = currentVideoURL,
              let videoData: Data = try? Data(contentsOf: currentVideoURL)else{
                return
        }
        SVProgressHUD.show()
        
        //3. Configuracion para guardar la foto en firebase
         let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "video/MP4"   //para que entienda que le vamos a poner el stroage

        //4. Referencia al storage de firebase
        let storage = Storage.storage()
        
        //5. crear nombre de la image
        let videoName = Int.random(in: 100...1000)
        
        //6. Referencia a donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "video-tweets/\(videoName).mp4")  //la ruta
        
        //7. Subir el video a firebase
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            folderReference.putData(videoData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription,  style: .warning).show()
                        return
                    }
                    //Obtener la URL de descarga
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        print("prueba storage",url )
                        let dowloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: nil, videoUrl: dowloadUrl)
                    }
                }
            }
        }
    }
    
    
    private func savePost(imageUrl: String?, videoUrl: String?) {
        //Crear un request de localizacion
        var postLocation: PostRequestLocation?
        if let userLocation = userLocation {
             postLocation = PostRequestLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

        }
        
        // 1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: imageUrl, videoUrl: videoUrl, location: postLocation)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: Endpoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
            case .success(let posts):
            
                print("response wito\(posts.hasLocation) aqui termina \n")
                NotificationBanner(title: "succes", subtitle: "sucedio bien. Bienvenido ", style: .success).show()
                self.dismiss(animated: true, completion: nil)
               //let home =  HomeViewController()
               // home.getPosts()
            case .error(let error):
                print("error wito",error)
                 NotificationBanner(title: "Error", subtitle: "Algo salio mal", style: .danger).show()
            case .errorResult(let entity):
                print("error con resultado", entity)
                 NotificationBanner(title: "error", subtitle: "\(entity)", style: .warning).show()
            }
        }
        
    }



}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Este metodo se dispara cuando terminamos de grabr o tomar foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // cerrar selector de fotos
        imagePicker?.dismiss(animated: true, completion: nil)
        //info es un dic, y entre sus llaves validamos que contenga el original image, y asi sabemos que tre imagen
        if info.keys.contains(.originalImage) {
            previewImageView.isHidden = false
            previewImageView.image = info[.originalImage] as? UIImage
        }
        // aqui capturamos la url del video
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL )?.absoluteURL {
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
    }
    
}

extension AddPostViewController:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last else {
            print("uso de hubicacion mal",locations.last )
            return
        }
        
        // ya tenemos la hubicacion mas cercana, esta variable "locations" nos trae sus cordenadas, latitud y longitud
        userLocation = bestLocation
        print("uso de hubicacion bien",userLocation )
    }}
