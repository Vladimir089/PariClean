//
//  AddBadHabitsViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 13.08.2024.
//

import UIKit

protocol AddBadHabitsViewControllerDelegate: AnyObject {
    func reloadCollection()
}


class AddBadHabitsViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    var selectedHabits = "Cigarette"
    var noImageView: UIImageView?
    
    var daysCollection: UICollectionView?
    let dayWeekArr = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    var selectedDay = "mon"
    
    var sortedCigarArr = cigarArr
    var sortedAlcoArr = alcoArr
    
    var mainCollection: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
        
        showNavigationBar()
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        sortArr()
        checkFillArr()
    }
    
    func createInterface() {
        
        daysCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .horizontal
            collection.showsHorizontalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.backgroundColor = .clear
            collection.dataSource = self
            collection.layer.cornerRadius = 6
            return collection
        }()
        view.addSubview(daysCollection!)
        daysCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(34)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        
        noImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if selectedHabits == "Cigarette" {
                imageView.image = UIImage.noSig
            } else {
                imageView.image = UIImage.noAlc
            }
            return imageView
        }()
        view.addSubview(noImageView!)
        noImageView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalTo(133)
            make.width.equalTo(240)
        })
        
        mainCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.showsHorizontalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.delegate = self
            collection.backgroundColor = .clear
            collection.dataSource = self
            collection.layer.cornerRadius = 6
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(daysCollection!.snp.bottom).inset(-15)
        })
        
        
        let addButton: UIButton = {
            let button = UIButton(type: .system)
            let imageView = UIImageView(image: .addNew)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(22)
                make.width.equalTo(55)
                make.center.equalToSuperview()
            }
            button.layer.cornerRadius = 12
            button.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
            return button
        }()
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        addButton.addTarget(self, action: #selector(newHabits), for: .touchUpInside)
       
        
    }
    
    @objc func newHabits() {
        let vc = NewHabitsViewController()
        vc.mainDelegate = self
        vc.habits = selectedHabits
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkFillArr() {
        if selectedHabits == "Cigarette" {
            if sortedCigarArr.count > 0 {
                mainCollection?.alpha = 1
                noImageView?.alpha = 0
            } else {
                mainCollection?.alpha = 0
                noImageView?.alpha = 1
            }
        } else {
            if sortedAlcoArr.count > 0 {
                mainCollection?.alpha = 1
                noImageView?.alpha = 0
            } else {
                mainCollection?.alpha = 0
                noImageView?.alpha = 1
            }
        }
    }
    
    func sortArr() {
        if selectedHabits == "Cigarette" {
            sortedCigarArr = []
            for i in cigarArr {
                if i.day == selectedDay {
                    sortedCigarArr.append(i)
                    print(i)
                }
            }
            mainCollection?.reloadData()
        } else {
            sortedAlcoArr = []
            for i in alcoArr {
                if i.day == selectedDay {
                    sortedAlcoArr.append(i)
                }
            }
            mainCollection?.reloadData()
        }
        
        
    }
    
    @objc func menuButtonTapped(_ sender: UIButton) {
        let firstAction = UIAction(title: "Edit", image: UIImage.pen.resize(targetSize: CGSize(width: 20, height: 20))) { _ in
            
            
            
            if self.selectedHabits == "Cigarette" {
                let vc = NewHabitsViewController()
                vc.isEdit = true
                
                var index = 0
                let item = self.sortedCigarArr[sender.tag]
                for i in cigarArr {
                    if i.day == item.day , i.number == item.number , i.reason == item.reason , i.time == item.time {
                        break
                    }
                    index += 1
                }
                
                vc.habits = self.selectedHabits
                vc.mainDelegate = self
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                
                let vc = NewHabitsViewController()
                vc.isEdit = true
                var index = 0
                let item = self.sortedAlcoArr[sender.tag]
                for i in alcoArr {
                    if i.day == item.day , i.number == item.number , i.reason == item.reason , i.time == item.time {
                        break
                    }
                    index += 1
                }
                
                vc.habits = self.selectedHabits
                vc.mainDelegate = self
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }

        let secondAction = UIAction(title: "Delete", image: UIImage.del.resize(targetSize: CGSize(width: 20, height: 20))) { _ in
            
            if self.selectedHabits == "Cigarette" {
                var index = 0
                let item = self.sortedCigarArr[sender.tag]
                for i in cigarArr {
                    if i.day == item.day , i.number == item.number , i.reason == item.reason , i.time == item.time {
                        cigarArr.remove(at: index)
                        return
                    }
                    index += 1
                }
                self.saveCigarArray(cigarArr)
            } else {
                var index = 0
                let item = self.sortedAlcoArr[sender.tag]
                for i in alcoArr {
                    if i.day == item.day , i.number == item.number , i.reason == item.reason , i.time == item.time {
                        alcoArr.remove(at: index)
                        return
                    }
                    index += 1
                }
                self.saveAlcoArray(alcoArr)
            }
            self.sortArr()
            self.checkFillArr()
            self.delegate?.reloadInfo()
        }
       

        let menu = UIMenu(title: "", children: [firstAction, secondAction])

        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
    
    func saveCigarArray(_ array: [AlcoSigar]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(array) {
            UserDefaults.standard.set(encoded, forKey: "cigar")
        }
    }
    
    func saveAlcoArray(_ array: [AlcoSigar]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(array) {
            UserDefaults.standard.set(encoded, forKey: "alco")
        }
    }
    
    
}


extension AddBadHabitsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == daysCollection {
            return dayWeekArr.count
        } else {
            if selectedHabits == "Cigarette" {
                return sortedCigarArr.count
            } else {
                return sortedAlcoArr.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == daysCollection  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .white.withAlphaComponent(0.05)
            cell.layer.cornerRadius = 6
            
            let label = UILabel()
            label.text = dayWeekArr[indexPath.row]
            label.textColor = .white
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            if selectedDay == label.text {
                cell.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
                label.textColor = .black
            } else {
                label.textColor = .white
                cell.backgroundColor = .white.withAlphaComponent(0.05)
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .white.withAlphaComponent(0.05)
            cell.layer.cornerRadius = 20
            
            let timeLabel = UILabel()
            timeLabel.textColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
            timeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            timeLabel.textAlignment = .left
            timeLabel.text = "d"
            cell.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.left.top.equalToSuperview().inset(15)
                make.right.equalToSuperview().inset(60)
            }
            
            let numberLabel = UILabel()
            numberLabel.textColor = .white.withAlphaComponent(0.7)
            numberLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            cell.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(timeLabel.snp.bottom).inset(-5)
            }
            
            let reasonLabel = UILabel()
            reasonLabel.textColor = .white
            reasonLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            reasonLabel.textAlignment = .left
            cell.addSubview(reasonLabel)
            reasonLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(15)
            }
            
            
            if selectedHabits == "Cigarette" {
                timeLabel.text = sortedCigarArr[indexPath.row].time
                numberLabel.text = "\(sortedCigarArr[indexPath.row].number) Cigarette"
                reasonLabel.text = sortedCigarArr[indexPath.row].reason
            } else {
                timeLabel.text = sortedAlcoArr[indexPath.row].time
                numberLabel.text = "\(sortedAlcoArr[indexPath.row].number) Glass"
                reasonLabel.text = sortedAlcoArr[indexPath.row].reason
            }
            
            let dopsButton = UIButton()
            dopsButton.setImage(.dopsButton.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
            cell.addSubview(dopsButton)
            dopsButton.tag = indexPath.row
            dopsButton.snp.makeConstraints { make in
                make.height.width.equalTo(32)
                make.right.top.equalToSuperview().inset(15)
                dopsButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == daysCollection {
            selectedDay = dayWeekArr[indexPath.row]
            daysCollection?.reloadData()
        }
        
        sortArr()
        checkFillArr()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == daysCollection {
            return CGSize(width: 46, height: 34)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 111)
        }
    }
    
    
}


extension AddBadHabitsViewController: AddBadHabitsViewControllerDelegate {
    func reloadCollection() {
        checkFillArr()
        mainCollection?.reloadData()
        daysCollection?.reloadData()
        delegate?.reloadInfo()
        sortArr()
    }
    
    
}
