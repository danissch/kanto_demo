//
//  RecordsViewController.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import UIKit
import NVActivityIndicatorView


class RecordsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewBack: UIView!
    @IBOutlet weak var activeBody: UIView!
    @IBOutlet weak var inactiveHeader: UIView!
    
    @IBOutlet weak var currentUserImageView: UIView!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentUsername: UILabel!
    @IBOutlet weak var currentUserBiography: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var currentProfileImage: UIImageView!
    
    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var headerConfigButton: UIButton!

    
    let maxHeaderHeight: CGFloat = 264
    let minHeaderHeight: CGFloat = 40
    var previousScrollOffset: CGFloat = 0
    let minRecordCellHeight:CGFloat = 414
    
    var loading:NVActivityIndicatorView!
    var coverView: UIView!
    
    var recordsViewModel:RecordsViewModelProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupDelegates()
        
        setupCustomCells()
        setUserInfoView()
        setActivityIndicatorConfig()
        loadRecords()
        loadUserData()
//        self.loading.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadUserData()
    }
    
    func setupViewModel(){
        let recordsViewModel = RecordsViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        recordsViewModel.networkService = NetworkService.get
        self.recordsViewModel = recordsViewModel as RecordsViewModelProtocol
    }
    
    func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        PersistanceManager.sharedInstance.delegate = self
        
    }
    func setupCustomCells(){
        let cell = UINib(nibName: "RecordTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "myCell")
    }
    
    func setUserInfoView(){
//        let userImageView = UserImageView.loadFromXib()
//        currentUserImageView.contentMode = .scaleAspectFill
//        userImageView.frame = CGRect(x: 0, y: 0, width: currentUserImageView.frame.width, height: currentUserImageView.frame.height)
//        currentUserImageView.addSubview(userImageView)
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: headerView.frame.origin.x, y: headerView.frame.origin.y - minHeaderHeight, width: headerView.frame.width, height: headerView.frame.height)
        layer.colors = [UIColor.init(red: 105/255, green: 72/255, blue: 243/255, alpha: 1.0).cgColor, UIColor.init(red: 125/255, green: 74/255, blue: 244/255, alpha: 1.0).cgColor, UIColor.init(red: 143/255, green: 75/255, blue: 241/255, alpha: 1.0).cgColor]
        headerViewBack.layer.addSublayer(layer)
        
        //EditProfile Button
        editProfileButton.layer.cornerRadius = 15
        
        
        
        inactiveHeader.backgroundColor = UIColor.init(red: 0/255, green: 33/255, blue: 58/255, alpha: 1.0)
        inactiveHeader.isHidden = true
        
        
        
        
    }
    
    func setActivityIndicatorConfig(){
        let view = UIView(frame: self.tabBarController?.view.frame ?? self.view.frame)
        coverView = view
        coverView.backgroundColor = .black
        coverView.alpha = 0.0
        loading = NVActivityIndicatorView(frame: coverView.frame, type: .ballSpinFadeLoader, color: .systemGray, padding: view.frame.width / 3)
        coverView.addSubview(loading)
        self.tabBarController?.view.addSubview(coverView)
    
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loading.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        loading.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func startActivityIndicator(){
        self.loading.startAnimating()
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.coverView?.alpha = 0.8
        })
    }
        
    func stopActivityIndicator(){
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 3){
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.coverView?.alpha = 0
            }) { (_) in
                    self.loading.stopAnimating()
            }
        }
    }
    
    func loadRecords() {
        startActivityIndicator()
        recordsViewModel?.getRecords() { [weak self] (result) in
            switch result {
            case .Success(_, _):
                self?.tableView.reloadData()
                self?.stopActivityIndicator()
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
                self?.stopActivityIndicator()
            }
        }
    }
    
    
    @IBAction func editProfileAction(_ sender: Any) {
        let vc = MyProfileViewController.instantiateFromXIB() as MyProfileViewController
        vc.delegate = self
        self.presentWithStyle1(vcFrom: self, vcTo: vc)
    }
    
    func loadUserData(){
        print("appflow:Records: loadUserData")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.currentProfileImage.image = UIImage(data:PersistanceManager.sharedInstance.profileImage)
//            self.currentProfileImage.image = PersistanceManager.sharedInstance.getSavedImage(named: "filePhotoUser")
//            print("appflow:: PersistanceManager.sharedInstance.readImage(): \(PersistanceManager.sharedInstance.readImage())")
//            self.currentProfileImage.image = UIImage(data: PersistanceManager.sharedInstance.readImage())
            
//        })
//        self.currentProfileImage.kf.setImage(with: URL(string: PersistanceManager.sharedInstance.profileImage))

        self.currentName.text = PersistanceManager.sharedInstance.profileName
        self.currentUsername.text = PersistanceManager.sharedInstance.profileUserName
        self.currentUserBiography.text = PersistanceManager.sharedInstance.profileBiography
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            PersistanceManager.sharedInstance.loadimg()
//            self.currentProfileImage.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//        })
    }
    
    

}



extension RecordsViewController:UITableViewDelegate {
    
    func canAnimateHeader (_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerViewHeight.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func setScrollPosition() {
        self.tableView.contentOffset = CGPoint(x:0, y: 0)
    }
}

extension RecordsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recordsViewModel?.recordsList.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recordsViewModel?.recordsList.count == 0  {
            startActivityIndicator()
            return UITableViewCell()
        }
        stopActivityIndicator()
        
        
//        let cell = RecordTableViewCell()
//        guard let cell = RecordTableViewCell(style: .default, reuseIdentifier: "myCell") as? RecordTableViewCell else {
//            return UITableViewCell()
//        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        
        if let record = recordsViewModel?.recordsList[indexPath.row] {
            cell.setCellData(record: record)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return minRecordCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}

extension RecordsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = (scrollView.contentOffset.y - previousScrollOffset)
        let isScrollingDown = scrollDiff > 0
        let isScrollingUp = scrollDiff < 0
        if canAnimateHeader(scrollView) {
            var newHeight = headerViewHeight.constant
            if isScrollingDown {
                newHeight = max(minHeaderHeight, headerViewHeight.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(maxHeaderHeight, headerViewHeight.constant + abs(scrollDiff))
            }
            if newHeight != headerViewHeight.constant {
                headerViewHeight.constant = newHeight
                setScrollPosition()
                previousScrollOffset = scrollView.contentOffset.y
                if headerViewHeight.constant == minHeaderHeight {
                    inactiveHeader.isHidden = false
                }else{
                    inactiveHeader.isHidden = true
                }
                
                
            }
        }
    }
}

extension RecordsViewController:MyProfileViewControllerDelegate {
    func onSaveData() {
        loadUserData()
    }
}
extension RecordsViewController:PersistanceManagerDelegate {
    func onLoadUserImg(img: UIImage) {
        self.currentProfileImage.image = img
    }
    

}

