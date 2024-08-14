//
//  AccountViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 14.08.2024.
//

import UIKit

protocol AccountViewControllerDelegate: AnyObject {
    func reload(data: User)
}

class AccountViewController: UIViewController {
    
    var imageView: UIImageView?
    var expLabel: UILabel?
    var nameLabel: UILabel?
    
    var user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        user = loadAthleteArrFromFile() ?? nil
        view.backgroundColor = .black
        createInterface()
        checkIsUser()
    }
    
    func checkIsUser() {
        if user != nil {
            imageView?.image = UIImage(data: user?.image ?? Data())
            nameLabel?.text = user?.name
            expLabel?.text = "Experience: \(user?.exp ?? "")"
        }
    }
    
    func loadAthleteArrFromFile() -> User? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("user.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode(User.self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    func createInterface() {
        
        let topLabel = UILabel()
        topLabel.text = "Account"
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topLabel.textColor = .white
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let midView = UIView()
        midView.backgroundColor = .white.withAlphaComponent(0.05)
        midView.layer.cornerRadius = 28
        view.addSubview(midView)
        midView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(293)
            make.top.equalTo(topLabel.snp.bottom).inset(-50)
        }
        
        let editButtin: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(.edit.resize(targetSize: CGSize(width: 20, height: 18)), for: .normal)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 24
            button.tintColor = .white.withAlphaComponent(0.5)
            return button
        }()
        midView.addSubview(editButtin)
        editButtin.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.right.top.equalToSuperview().inset(15)
        }
        editButtin.addTarget(self, action: #selector(openVC), for: .touchUpInside)
        
        imageView = {
            let imageView = UIImageView()
            imageView.image = .noImageAcc
            imageView.layer.cornerRadius = 65
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        midView.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(130)
            make.centerX.equalToSuperview()
            make.top.equalTo(editButtin.snp.bottom)
        })
        
        nameLabel = {
            let label = UILabel()
            label.text = "Username"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textAlignment = .center
            return label
        }()
        midView.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        })
        
        expLabel = {
            let label = UILabel()
            label.text = "Experience: 0 days"
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = .white.withAlphaComponent(0.5)
            return label
        }()
        midView.addSubview(expLabel!)
        expLabel!.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel!.snp.bottom).inset(-5)
        }
        
        let botView = UIView()
        botView.backgroundColor = .white.withAlphaComponent(0.05)
        botView.layer.cornerRadius = 28
        view.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(154)
            make.top.equalTo(midView.snp.bottom).inset(-20)
        }
        
        let imageViewCup = UIImageView(image: .cup.resize(targetSize: CGSize(width: 27, height: 28)))
        imageViewCup.contentMode = .scaleAspectFit
        botView.addSubview(imageViewCup)
        imageViewCup.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        let achLabel = UILabel()
        achLabel.text = "Achievement"
        achLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        achLabel.textColor = .white
        botView.addSubview(achLabel)
        achLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let achButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Open", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 17
            button.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.24)
            return button
        }()
        botView.addSubview(achButton)
        achButton.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(66)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        achButton.addTarget(self, action: #selector(openAch), for: .touchUpInside)
        
    }
    
    @objc func openAch() {
        let vc = AchivementViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openVC() {
        let vc = EditAccountViewController()
        vc.delegate = self
        
        if user != nil {
            print(123)
            vc.name = user?.name
            vc.image = UIImage(data: user?.image ?? Data())
            vc.exp = user?.exp
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension AccountViewController: AccountViewControllerDelegate {
    func reload(data: User) {
        self.user = data
        imageView?.image = UIImage(data: user?.image ?? Data())
        nameLabel?.text = user?.name
        expLabel?.text = "Experience: \(user?.exp ?? "")"
    }
    
    
}
