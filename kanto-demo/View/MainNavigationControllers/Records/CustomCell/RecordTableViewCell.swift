//
//  RecordTableViewCell.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation
import UIKit
import Kingfisher
import Lottie
import AVKit

class RecordTableViewCell: UITableViewCell {
    
    var currentRecord:Record?
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var videoPreviewContainer: UIView!
    @IBOutlet weak var imageViewPreview: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var favAnimationContainer: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var letsPlayContainer: UIView!
    @IBOutlet weak var playButton: UIButton!

    private var animationView: AnimationView?
    private var videoLayer:UIView!

    var player: AVPlayer!
    var playerLayer:AVPlayerLayer!
    var avpController: AVPlayerViewController!
    var urlUserPhoto:String?
    var headName:String?
    var previewImgUrl:String?
    var videoUrl:String?
    var songName:String?
    var isFavorite:Bool?
    
    var widthForVideo:CGFloat = 310
    var heigtForVideo:CGFloat = 310
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.letsPlayContainer.isHidden = true
        setMainConfigurationsCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.urlUserPhoto = nil
        self.headName = nil
        self.previewImgUrl = nil
        self.videoUrl = nil
        self.songName = nil
        self.isFavorite = false
        self.currentRecord = nil
        self.player = nil
        self.playerLayer = nil
        
    }
    
    func setCellData(record:Record?){
        if let rec = record {
            self.currentRecord = rec
            self.urlUserPhoto = rec.profile?.img
            self.headName = rec.profile?.name
            self.previewImgUrl = rec.previewImg
            self.videoUrl = rec.recordVideo
            self.songName = rec.recordDescription
            self.isFavorite = false
            
            configureUserPhotoContainer()
            configureUsernameLabel()
            configureVideoPreviewContainer()
            configureSongNameLabel()
            configureFavAnimationContainer()
            
        }

    }
    private func setMainConfigurationsCell(){
        configureCellContainer()
        cellContainer.clipsToBounds = true
        cellContainer.layer.cornerRadius = 10
        cellContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        photoUser.clipsToBounds = true
        photoUser.layer.cornerRadius = photoUser.frame.height / 2
    }
    private func configureCellContainer(){
        self.cellContainer.backgroundColor = UIColor.init(red: 37/255, green: 37/255, blue: 37/255, alpha: 1.0)
        self.footerContainer.backgroundColor = self.cellContainer.backgroundColor
    }
    
    private func configureUserPhotoContainer(){
        self.setMainImage(url: self.urlUserPhoto ?? "", imageView: photoUser)
    }
    
    private func configureUsernameLabel(){
        self.usernameLabel.text = self.headName
        self.usernameLabel.textColor = .white
    }
    
    private func configureVideoPreviewContainer(){
        self.setMainImage(url: self.previewImgUrl ?? "", imageView: imageViewPreview)
        installVideo()
        
    }
    
    private func configureSongNameLabel(){
        self.songNameLabel.text =  self.songName
    }
    
    private func configureViewsLabel(){}
    
    private func configureFavAnimationContainer(){
        animationView = .init(name:"fav")
        animationView?.frame = CGRect(x: 0, y: 0, width: favAnimationContainer.frame.width, height: favAnimationContainer.frame.height)
        animationView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.favAnimationContainer.addSubview(animationView!)
        animationView?.contentMode = .scaleAspectFill
        animationView!.animationSpeed = 0.5
        let gestureFavorite = UITapGestureRecognizer(target: self, action:  #selector(self.favAction))
        animationView?.addGestureRecognizer(gestureFavorite)
        setFavStatus()
        self.likeLabel.textColor = .white
        
    }
    
    func setMainImage(url: String, imageView: UIImageView){
        if let url = URL(string: url) {
            imageView.kf.setImage(with: url)
        }
    }
    
    @objc func favAction(sender : UITapGestureRecognizer) {
        isFavorite ?? false ? delFav() : addFav()
    }
    
    private func startProgress() {
      animationView?.play(fromFrame: 0, toFrame: 0, loopMode: .none) { [weak self] (_) in
        self?.isFavorite = false
      }
    }
    
    private func fullProgress(){
        animationView?.play(fromFrame: 100, toFrame: 100, loopMode: .none) { [weak self] (_) in
            self?.isFavorite = true
        }
    }
    
    private func setFavStatus(){
        isFavorite ?? false ? fullProgress() : startProgress()
    }
    
    private func addFav() {
        fullProgress()
    }
        
    private func delFav(){
        startProgress()
    }
    
    func installVideo(){
        if let url = URL(string:self.videoUrl ?? "") {
            avpController = AVPlayerViewController()
            player = AVPlayer(url: url)
            avpController.player = player
            avpController.view.frame = self.videoPreviewContainer.bounds
            avpController.showsPlaybackControls = true
            self.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            avpController.contentOverlayView?.addSubview(imageViewPreview)
            avpController.contentOverlayView?.frame = CGRect(x: 0, y: 0, width: 310, height: 310)
            self.videoPreviewContainer.addSubview(avpController.view)
            try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
            
            self.videoPreviewContainer.autoresizesSubviews = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if let playRate = self.player?.rate {
                if playRate == 0.0 {
                    print("appflow:: playback paused")
                } else {
                    print("appflow:: playback started")
                    avpController.contentOverlayView?.isHidden = true
                }
            }
        }
    }
    
    
    @IBAction func playButtonAction(_ sender: Any) {
        avpController.player?.play()
    }
    
}
