//
//  AchivementViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 14.08.2024.
//

import UIKit

class AchivementViewController: UIViewController {
    
    var arrCompletedInexes: [Int] = []

    var arrImage: [(UIImage, String)] = [
        (UIImage(named: "noOne")!, "Complete your first day without a bad habit"),
        (UIImage(named: "noTwo")!, "Go seven days without any bad habits"),
        (UIImage(named: "noThree")!, "Go 30 days without any bad habits"),
        (UIImage(named: "noFour")!, "Get back on track after three setbacks"),
        (UIImage(named: "noFive")!, "Discover a new way to combat a bad habit"),
        (UIImage(named: "noSix")!, "Share your progress with friends on social media"),
        (UIImage(named: "noSeven")!, "Eliminate bad habits for an entire month without"),
        (UIImage(named: "noEadge")!, "Create and follow a personalized achievement plan"),
        (UIImage(named: "noNine")!, "Help another person start their journey to quit bad habits")
    ]
    
    
    var collection: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAchivements()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        createInterface() 
        
    }
    
    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Achievement"
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topLabel.textColor = .white
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let exitButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 12
            button.setImage(.xmark.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal)
            return button
        }()
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.left.equalToSuperview().inset(15)
            make.centerY.equalTo(topLabel)
        }
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).inset(-30)
        })
        
       
    }
   
    @objc func exit() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkAchivements() {
        //1 ach, 2, 3 ach
        if let data = UserDefaults.standard.array(forKey: "Home") as? [Int] {
            if data[0] >= 1 {
                arrImage[0].0 = UIImage.yesOne
            }
            if data[0] >= 7 {
                arrImage[1].0 = UIImage.yesTwo
            }
            if data[0] >= 30 {
                arrImage[2].0 = UIImage.yesThree
            }
        }
        //4 ach
        var cig = 0
        for i in cigarArr {
            cig += i.number
        }
        for i in alcoArr {
            cig += i.number
        }
        if cig >= 3 {
            arrImage[3].0 = UIImage.yesFour
        }
        
        
        arrCompletedInexes = UserDefaults.standard.array(forKey: "ach") as? [Int] ?? []
        
        for i in arrCompletedInexes {
            switch i {
            case 4:
                arrImage[4].0 = UIImage.yesFive
            case 5:
                arrImage[5].0 = UIImage.yesSix
            case 6:
                arrImage[6].0 = UIImage.yesSeven
            case 7:
                arrImage[7].0 = UIImage.yesEdge
            case 8:
                arrImage[8].0 = UIImage.yesNine
            default:
                return
            }
        }
        
        
        collection?.reloadData()
    }
    
    
    
    
    
    
}

extension AchivementViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .black
        
        let imageView = UIImageView(image: arrImage[indexPath.row].0)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 53
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(106)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(2)
        }
        
        let label = UILabel()
        label.text = arrImage[indexPath.row].1
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-5)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrCompletedInexes.append(indexPath.row)
        UserDefaults.standard.setValue(arrCompletedInexes, forKey: "ach")
        checkAchivements()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 163)
    }
    
    
}
