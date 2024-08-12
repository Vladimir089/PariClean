//
//  UserOnbViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//

import UIKit

class UserOnbViewController: UIViewController {
    
    var topLabel: UILabel?
    
    var tap = 0
    
    var dots: [UIView] = []
    var imageView: UIImageView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createDots()
        createInterfave()
    }
    

    func createInterfave() {
        
        topLabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.numberOfLines = 2
            label.text = "Your path to better \n habits"
            label.textAlignment = .center
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 0.55)
        grayView.layer.cornerRadius = 12
        view.addSubview(grayView)
        grayView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.top.equalTo(topLabel!.snp.bottom).inset(-30)
        }
        
        
        grayView.addSubview(dots[1])
        dots[1].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.centerX.centerY.equalToSuperview()
        }
        
        
        grayView.addSubview(dots[0])
        dots[0].backgroundColor = .white
        dots[0].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        grayView.addSubview(dots[2])
        dots[2].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        imageView = {
            let imageView = UIImageView(image: .us1)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(520)
            make.top.equalTo(grayView.snp.bottom).inset(-15)
        })
        
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        nextButton.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
        nextButton.layer.cornerRadius = 12
        nextButton.setTitleColor(.black, for: .normal)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
    
    @objc func nextPage() {
        tap += 1
        
        for i in dots {
            if i.backgroundColor == .white {
                i.backgroundColor = .white.withAlphaComponent(0.3)
            }
        }
        
        switch tap {
        case 1:
            UIView.animate(withDuration: 0.2) {
                self.dots[1].backgroundColor = .white
                self.imageView?.image = UIImage.us2
            }
            topLabel?.text = "Keep track of your \n achievements!"
        case 2:
            UIView.animate(withDuration: 0.2) {
                self.dots[2].backgroundColor = .white
                self.imageView?.image = UIImage.us3
            }
            topLabel?.text = "It's easy to add bad \n habits!"
        case 3:
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        default:
            return
        }
        
    }
    
    
    
    func createDots() {
        for _ in 0..<3 {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.3)
            view.layer.cornerRadius = 4
            dots.append(view)
        }
        
    }

}
