//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by mac1 on 15/09/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit


class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var  nameLabel: UILabel!
    @IBOutlet weak var  nicknameLabel: UILabel!
    @IBOutlet weak var  messageLabel: UILabel!
    @IBOutlet weak var  tweetImageView: UIImageView!
    @IBOutlet weak var  videoButton: UIButton!
    @IBOutlet weak var  dateLabel: UILabel!
    
    @IBOutlet weak var  imagenPerfil: UIImageView!
    
    

    /*  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // setUpCellWith()
       
    }*/

 /*   override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    
    func setUpCellWith(post: Post ){
     //   imagenPerfil.layer.cornerRadius
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        messageLabel.text = post.text
        dateLabel.text = post.createdAt
        
        if post.hasImage {
            // configurar imagen/ kf, nos ayuda a traer imagenes desde la red
            self.tweetImageView.isHidden = false
            self.videoButton.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        } else {
            self.tweetImageView.isHidden = true
            self.videoButton.isHidden = true
        }
        if post.hasVideo {
            self.tweetImageView.isHidden = false
            self.videoButton.isHidden = false
            
            let avPlayer = AVPlayer(url:(URL(string: post.videoUrl ) ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/platsitweets.appspot.com/o/video-tweets%2F786.mp4?alt=media&token=bb70ce73-e4f2-4ed4-9a3d-868cfb483d63"))! )            // este es el AVPlayer
            
            let avPlayerController =  AVPlayerViewController()        //este es el que levanta la vista para reproducir el video
            avPlayerController.player = avPlayer
            
            /*present(avPlayerController, animated: true){
                avPlayerController.player?.play()
            }*/
        }
    }
}
