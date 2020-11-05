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
    
    @IBOutlet weak var userSmokeImage: UIImageView!
    @IBOutlet weak var layerOrnamentImageProfile: UIView!
    @IBOutlet weak var currentProfileImage: UIImageView!
    
    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var headerConfigButton: UIButton!

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var counterStackView: UIStackView!
    @IBOutlet weak var topConstraintCounters: NSLayoutConstraint!
    
    var newHeightHeader:CGFloat!
    let maxHeaderHeight: CGFloat = 300
    let minHeaderHeight: CGFloat = 44
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
        setHeaderBehavior(headerActive: false)
        setupCountersViewFeatures()
        setHeaderViewConfig()
        setColoredBackHeader()
        setActivityIndicatorConfig()
        loadRecords()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setColoredBackHeader()
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
        self.currentName.text = PersistanceManager.sharedInstance.profileName
        self.currentUsername.text = "@\(PersistanceManager.sharedInstance.profileUserName)"
        self.currentUserBiography.text = PersistanceManager.sharedInstance.profileBiography
        self.headerName.text = PersistanceManager.sharedInstance.profileName
        PersistanceManager.sharedInstance.loadimg()
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
            newHeightHeader = headerViewHeight.constant
            
            if isScrollingDown {
                newHeightHeader = max(minHeaderHeight, headerViewHeight.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeightHeader = min(maxHeaderHeight, headerViewHeight.constant + abs(scrollDiff))
            }
            
            if newHeightHeader != headerViewHeight.constant {
                headerViewHeight.constant = newHeightHeader
                setScrollPosition()
                previousScrollOffset = scrollView.contentOffset.y
                if headerViewHeight.constant == minHeaderHeight {
                    setHeaderBehavior(headerActive: true)
                }else{
                    setHeaderBehavior(headerActive: false)
                }
    
               
                if newHeightHeader <= maxHeaderHeight - footerView.frame.height{
                    footerView.fadeOut()
                }else{
                    footerView.fadeIn()
                }
                
                if newHeightHeader <= maxHeaderHeight - (footerView.frame.height + editProfileButton.frame.height){
                    editProfileButton.fadeOut()
                    
                }else{
                    editProfileButton.fadeIn()
                }
                
                if newHeightHeader <= maxHeaderHeight - (footerView.frame.height + editProfileButton.frame.height +  currentUserBiography.frame.height){
                    currentUserBiography.fadeOut()
                }else{
                    currentUserBiography.fadeIn()
                }
                
                if newHeightHeader <= maxHeaderHeight - (footerView.frame.height + editProfileButton.frame.height +  currentUserBiography.frame.height + currentUsername.frame.height){
                    currentUsername.fadeOut()
                }else{
                    currentUsername.fadeIn()
                }
                
                let sumCurrentName = footerView.frame.height + editProfileButton.frame.height + currentUserBiography.frame.height + currentUsername.frame.height + currentName.frame.height
                if newHeightHeader <= maxHeaderHeight - (sumCurrentName){
                    currentName.fadeOut()
                }else{
                    currentName.fadeIn()
                }
                
                let sumCurrentUserImageView = footerView.frame.height + editProfileButton.frame.height + currentUserBiography.frame.height + currentUsername.frame.height + currentName.frame.height + currentUserImageView.frame.height
                if newHeightHeader <= maxHeaderHeight - (sumCurrentUserImageView) {
                    currentUserImageView.fadeOut()
                }else{
                    currentUserImageView.fadeIn()
                }
                
            }
        }
    }

    
    func setHeaderBehavior(headerActive: Bool = false){
        editProfileButton.layer.cornerRadius = 14
        inactiveHeader.backgroundColor = UIColor.init(red: 0/255, green: 33/255, blue: 58/255, alpha: 1.0)
        setProfilePhotoSettings()

        if headerActive {
            inactiveHeader.isHidden = false
            inactiveHeader.fadeIn()

            headerView.clipsToBounds = false
    
        }else {
            inactiveHeader.fadeOut()
            inactiveHeader.isHidden = true
            
            headerView.clipsToBounds = true
  
        }
        
    }
    
    func setProfilePhotoSettings(){
        self.currentUserImageView.clipsToBounds = true
        self.currentUserImageView.layer.borderWidth = 1.0
        self.currentUserImageView.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.2).cgColor
        self.currentUserImageView.layer.cornerRadius = currentUserImageView.frame.height / 2
        
        self.userSmokeImage.clipsToBounds = true
        self.userSmokeImage.layer.cornerRadius = self.userSmokeImage.frame.height / 2
        
        self.currentProfileImage.clipsToBounds = true
        self.currentProfileImage.layer.cornerRadius = self.currentProfileImage.frame.height / 2
        
        self.layerOrnamentImageProfile.clipsToBounds = true
        self.layerOrnamentImageProfile.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.6).cgColor
        self.layerOrnamentImageProfile.layer.borderWidth = 1.0
        self.layerOrnamentImageProfile.layer.cornerRadius = self.layerOrnamentImageProfile.frame.height / 2
        
    }
    
    func setHeaderViewConfig(){
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setColoredBackHeader(){
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.headerView.frame.height)
        layer.colors = [UIColor.init(red: 105/255, green: 72/255, blue: 243/255, alpha: 1.0).cgColor, UIColor.init(red: 125/255, green: 74/255, blue: 244/255, alpha: 1.0).cgColor, UIColor.init(red: 143/255, green: 75/255, blue: 241/255, alpha: 1.0).cgColor]
        headerViewBack.clipsToBounds = true
        headerViewBack.layer.addSublayer(layer)
    }
    
    func setupCountersViewFeatures(){
        counterStackView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        counterStackView.clipsToBounds = true
        counterStackView.layer.cornerRadius = 16
        
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

