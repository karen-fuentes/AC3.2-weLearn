//
//  ProfileViewController.swift
//  weLearn
//
//  Created by Marty Avedon on 3/7/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import AudioToolbox
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var achievements: [Achievement]? {
        didSet {
            User.manager.achievements = achievements
        }
    }
    
    var testGrades: TestGrade?
    var databaseReference: FIRDatabaseReference!
    var gradesParsed: [(assignment: String, grade: String)] = [] {
        didSet {
            User.manager.grades = gradesParsed
        }
    }
    
    var gradesSheetID = MyClass.manager.studentGradesID!
    var achievementsSheetID = MyClass.manager.achievementsID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = "Profile"
        self.tabBarController?.title = navigationItem.title
        
        viewHeirarchy()
        configureConstraints()
        
        self.edgesForExtendedLayout = .bottom
        
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: "GradeTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        tableView.separatorStyle = .none
        
        profilePic.layer.cornerRadius = 50
        profilePic.clipsToBounds = true
        
        databaseReference = FIRDatabase.database().reference()
        
        if User.manager.studentKey != nil {
            getProfileImage()
        }
        
        let rightButton = UIBarButtonItem(customView: logOutButton)
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        logOutButton.addTarget(self, action: #selector(logOutButtonWasPressed(selector:)), for: .touchUpInside)
        getChievos()
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(false)
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        uploadImageButton.layer.borderColor = UIColor.black.cgColor
        uploadImageButton.layer.borderWidth = 1
        
        //        if gradesParsed.isEmpty {
        startGrabbingTestData()
        //        }
        
        //        if achievements == nil {
        getChievos()
        //        }
        if User.manager.studentKey != nil {
            getProfileImage()
        }
    }
    
    func getChievos() {
        //        if User.manager.achievements == nil {
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(achievementsSheetID)/od6/public/basic?alt=json") { (data: Data?) in
            if data != nil {
                if let returnedAnnouncements = AchievementBucket.getStudentAchievementBucket(from: data!, for: User.manager.id!) {
                    DispatchQueue.main.async {
                        self.achievements = AchievementBucket.parseBucketString(returnedAnnouncements.contentString)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        //        }
//        else {
//            self.collectionView.reloadData()
//        }
    }
    
    func getProfileImage() {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profileImage/\(User.manager.studentKey!)")
        
        imageRef.data(withMaxSize: 1*1024*1024) { (data, error) in
            if let error = error {
                print(error)
            }
            else {
                let image = UIImage(data: data!)
                self.profilePic.image = image
            }
        }
    }
    
    //MARK: - Views
    
    func viewHeirarchy() {
        self.view.addSubview(activityIndicator)
        self.view.addSubview(profileBox)
        self.view.addSubview(profilePic)
        self.view.addSubview(nameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(classLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(collectionView)
        self.view.addSubview(uploadImageButton)
        self.view.addSubview(presentAchievement)
        self.presentAchievement.addSubview(achievementPic)
        self.presentAchievement.addSubview(achievementLabel)
    }
    
    func configureConstraints() {
        activityIndicator.snp.makeConstraints { view in
            view.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (tV) in
            tV.leading.trailing.bottom.equalToSuperview()
            tV.top.equalTo(collectionView.snp.bottom).offset(10)
        }
        
        collectionView.snp.makeConstraints { (cV) in
            cV.leading.trailing.equalToSuperview()
            cV.top.equalTo(profileBox.snp.bottom)
            cV.height.equalTo(150)
        }
        
        profileBox.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.centerX.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
        }
        
        uploadImageButton.snp.makeConstraints { (view) in
            view.top.equalTo(profilePic.snp.bottom).offset(10)
            // view.top.equalTo(profilePic.snp.bottom).offset(8)
            view.leading.equalTo(profileBox).offset(33)
            view.bottom.equalTo(profileBox).inset(10)
            view.width.equalTo(100)
            view.height.equalTo(30)
        }
        
        profilePic.snp.makeConstraints { view in
            //view.top.leading.equalTo(profileBox).offset(8)
            view.top.equalTo(profileBox).offset(10)
            view.leading.equalTo(profileBox).offset(33)
            view.width.height.equalTo(100)
            view.height.equalTo(profilePic.snp.width)
        }
        
        nameLabel.snp.makeConstraints { view in
            view.top.equalTo(profileBox).offset(30)
            view.trailing.equalTo(profileBox).inset(45)
        }
        
        emailLabel.snp.makeConstraints { view in
            view.top.equalTo(nameLabel.snp.bottom).offset(10)
            view.trailing.equalTo(profileBox).inset(45)
        }
        
        classLabel.snp.makeConstraints { view in
            view.top.equalTo(emailLabel.snp.bottom).offset(5)
            view.trailing.equalTo(profileBox).inset(45)
        }
        
        self.presentAchievement.snp.makeConstraints { view in
            view.leading.equalTo(collectionView.snp.trailing)
            view.bottom.equalTo(collectionView)
        }
        
        self.achievementPic.snp.makeConstraints { view in
            view.top.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().inset(10)
            view.width.equalTo(245)
            view.height.equalTo(245)
        }
        
        self.achievementLabel.snp.makeConstraints { view in
            view.top.equalTo(achievementPic.snp.bottom).offset(10)
            view.leading.trailing.equalTo(presentAchievement)
            view.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    //MARK: - User Functions
    
    func startGrabbingTestData() {
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        
        //        if User.manager.grades == nil {
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(gradesSheetID)/od6/public/basic?alt=json") { (data: Data?) in
            if data != nil {
                self.fetchStudentTestData(data!)
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        //        }
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    func fetchStudentTestData(_ data: Data) {
        
        // Now that we have the number, grab that person's grades
        if let studentID = User.manager.id {
            if let returnedGradesData = TestGrade.getStudentTestGrade(from: data,
                                                                      for: studentID) {
                print("\n\n\nWe've got grades for: \(returnedGradesData.id)")
                
                self.testGrades = returnedGradesData
                self.gradesParsed = TestGrade.parseGradeString(self.testGrades!.grades)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - UIImagePicker Delegate Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePic.image = image
            // let postRef = self.databaseReference.childByAutoId()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://welearn-a2b14.appspot.com/")
            let spaceRef = storageRef.child("profileImage/\(User.manager.studentKey!)")
            
            let data = UIImageJPEGRepresentation(image, 0.25)
            let metaData = FIRStorageMetadata()
            metaData.cacheControl = "public,max-age=300";
            metaData.contentType = "image/jpeg";
            
            let _ = spaceRef.put(data!, metadata: metaData, completion: { (metaData, error) in
                guard metaData != nil else {
                    print("Error in putting data")
                    return
                }
            })
            
            print("appending \(image)")
        }
        
        dismiss(animated: true) {
        }
    }
    
    // MARK: - Collectionview stuff
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.manager.achievements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCollectionViewCell", for: indexPath)
        
        if let achievementsUnwrapped = User.manager.achievements {
            if achievementsUnwrapped.count > 0 {
                if let achievementCell = cell as? AchievementCollectionViewCell {
                    achievementCell.achievementPic.image = UIImage(named: achievementsUnwrapped[indexPath.row].pic)
                    achievementCell.descriptionLabel.text = achievements?[indexPath.row].description
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Table view stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let loadedGrades = User.manager.grades {
            return loadedGrades.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "GradeTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        /*
         if let loadedGrades = User.manager.grades {
         if let gradeCell = cell as? GradeTableViewCell {
         let grades = loadedGrades[indexPath.row]
         gradeCell.testNameLabel.text = grades.assignment
         gradeCell.gradeLabel.text = grades.grade
         */
        
        if let gradeCell = cell as? GradeTableViewCell {
            let grades = gradesParsed[indexPath.row]
            gradeCell.testNameLabel.text = grades.assignment
            gradeCell.gradeLabel.text = grades.grade
            
            if (gradeCell.testNameLabel.text?.lowercased().contains("average"))! {
                gradeCell.testNameLabel.font = UIFont(name: "Avenir-Roman", size: 24)
                gradeCell.gradeLabel.font = UIFont(name: "Avenir-Oblique", size: 24)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1103)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1104)
        
        let currentCell = collectionView.cellForItem(at: indexPath) as! AchievementCollectionViewCell
        
        achievementPic.image = currentCell.achievementPic.image
        achievementLabel.text = currentCell.descriptionLabel.text
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.presentAchievement.snp.remakeConstraints { (view) in
            view.centerX.equalTo(collectionView)
            view.centerY.equalTo(collectionView)
        }
        
        animator.startAnimation()
    }
    
    //Mark: - Button Functions
    
    func logOutButtonWasPressed(selector: UIButton) {
        AudioServicesPlaySystemSound(1105)
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                self.navigationController?.navigationBar.isHidden = true
                selector.isHidden = true
                self.dismiss(animated: true, completion: nil)
                User.logOut()
            }
                
            catch {
                print(error)
            }
        }
    }
    
    func uploadImageButtonWasTouched() {
        AudioServicesPlaySystemSound(1104)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.uploadImageButton.layer.shadowOpacity = 0.1
            self.uploadImageButton.layer.shadowRadius = 1
            self.uploadImageButton.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.1), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            self.uploadImageButton.layer.shadowOpacity = 0.25
            self.uploadImageButton.layer.shadowRadius = 2
            self.uploadImageButton.layer.sublayers!.remove(at: 0)
        })
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func presentAchievementWasPressed() {
        AudioServicesPlaySystemSound(1104)
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.presentAchievement.snp.remakeConstraints { (view) in
            view.trailing.equalTo(collectionView.snp.leading)
        }
        
        animator.startAnimation()
    }
    
    // Mark: - Views made here
    
    lazy var profileBox: UIImageView = {
        let view = UIImageView()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.image = #imageLiteral(resourceName: "clouds")
        view.contentMode = .bottom
        view.backgroundColor = UIColor.weLearnBlue
        return view
    }()
    
    lazy var profilePic: UIImageView = {
        let pic = UIImageView()
        pic.layer.borderColor = UIColor.weLearnCoolWhite.cgColor
        pic.backgroundColor = UIColor.white
        pic.contentMode = .scaleAspectFill
        pic.layer.borderWidth = 3
        return pic
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.weLearnBlack
        label.text = User.manager.name ?? "Anon"
        label.font = UIFont(name: "Avenir-Light", size: 28)
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.weLearnBlack
        label.text = User.manager.email ?? "anon@anon.com"
        label.font = UIFont(name: "Avenir-Roman", size: 20)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.weLearnBlack
        label.text = User.manager.classroom ?? "No class"
        label.font = UIFont(name: "Avenir-Roman", size: 20)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "AchievementCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var uploadImageButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("Upload Pic".uppercased(), for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(uploadImageButtonWasTouched), for: .touchUpInside)
        return button
    }()
    
    lazy var presentAchievement: Box = {
        let view = Box()
        view.addTarget(self, action: #selector(presentAchievementWasPressed), for: .touchUpInside)
        return view
    }()
    
    lazy var achievementLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    let achievementPic: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .scaleAspectFit
        return pic
    }()
    
    lazy var logOutButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("Log Out".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnBlue, for: .normal)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.hidesWhenStopped = true
        view.color = UIColor.weLearnGreen
        return view
    }()
}
