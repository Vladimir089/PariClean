//
//  HomeViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//

import UIKit

var cigarArr = [AlcoSigar]()
var alcoArr = [AlcoSigar]()

protocol HomeViewControllerDelegate: AnyObject {
    func reloadDiagramm(allDays: Int, totalDays: Int)
    func openVC(selected: Int)
    func reloadInfo()
}

class HomeViewController: UIViewController {
    
    let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 150, height: 150), lineWidth: 5, rounded: true)
    
    var progress = [0, 31]
    var progressLabel: UILabel?
    
    var wineLabel, cigaretesLabel: UILabel?
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        checkData()
        loadArrs()
    }
    
    func loadArrs() {
        cigarArr = loadCigarArray() ?? []
        alcoArr = loadAlcoArray() ?? []
        reloadInfo()
    }
    
    func loadCigarArray() -> [AlcoSigar]? {
        if let savedCigars = UserDefaults.standard.object(forKey: "cigar") as? Data {
            let decoder = JSONDecoder()
            if let loadedCigars = try? decoder.decode([AlcoSigar].self, from: savedCigars) {
                return loadedCigars
            }
        }
        return nil
    }
    
    func loadAlcoArray() -> [AlcoSigar]? {
        if let savedCigars = UserDefaults.standard.object(forKey: "alco") as? Data {
            let decoder = JSONDecoder()
            if let loadedCigars = try? decoder.decode([AlcoSigar].self, from: savedCigars) {
                return loadedCigars
            }
        }
        return nil
    }
    
    func checkData() {
        if let data = UserDefaults.standard.array(forKey: "Home") as? [Int] {
            progress = data
        } else {
            progress = [0, 31]
        }
        fillProgress()
    }
    
    func fillProgress() {
        let oneProg = Float(progress[0])
        let twoProg = Float(progress[1])
        
        progressView.progress = oneProg / twoProg
        progressLabel?.text = "\(progress[0])/\(progress[1])"
    }
    
    @objc func openEditDays() {
        let vc = EditDiagramViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    

    func createInterface() {
        let homeLabel = UILabel()
        homeLabel.text = "Home"
        homeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        homeLabel.textColor = .white
        view.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let midView = UIView()
        midView.backgroundColor = .white.withAlphaComponent(0.08)
        midView.layer.cornerRadius = 28
        view.addSubview(midView)
        midView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(293)
            make.top.equalTo(homeLabel.snp.bottom).inset(-50)
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
        editButtin.addTarget(self, action: #selector(openEditDays), for: .touchUpInside)
        
        progressView.progressColor = .white
        progressView.trackColor = .white.withAlphaComponent(0.08)
        midView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.center.equalToSuperview()
        }
        
        progressLabel = {
            let label = UILabel()
            label.text = "\(progress[0])/\(progress[1])"
            label.font = .systemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
            return label
        }()
        midView.addSubview(progressLabel!)
        progressLabel?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        
        let daysLabel = UILabel()
        daysLabel.text = "Days without bad habits"
        daysLabel.font = .systemFont(ofSize: 28, weight: .bold)
        daysLabel.textColor = .white
        midView.addSubview(daysLabel)
        daysLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        let cigView = createViews(tag: 1)
        view.addSubview(cigView)
        cigView.snp.makeConstraints { make in
            make.height.equalTo(154)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.top.equalTo(midView.snp.bottom).inset(-15)
        }
        
        let wineView = createViews(tag: 2)
        view.addSubview(wineView)
        wineView.snp.makeConstraints { make in
            make.height.equalTo(154)
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.top.equalTo(midView.snp.bottom).inset(-15)
        }
        
        let openButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 0/255, alpha: 1)
            button.setImage(UIImage.plus.resize(targetSize: CGSize(width: 30, height: 30)), for: .normal)
            button.layer.cornerRadius = 37.5
            return button
        }()
        view.addSubview(openButton)
        openButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
            make.centerX.equalToSuperview()
            make.top.equalTo(wineView.snp.bottom).inset(-15)
        }
        openButton.addTarget(self, action: #selector(openDetail), for: .touchUpInside)
        
    }
    
    @objc func openDetail() {
        let vc = DetailAddViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func openBadHabits(sender: UIButton) {
        openVC(selected: sender.tag)
    }
    
    func createViews(tag: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.08)
        view.layer.cornerRadius = 16
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(41)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        if tag == 1 {
            
            imageView.image = UIImage.cigar
            
            cigaretesLabel = UILabel()
            cigaretesLabel?.text = "0 cigarette"
            cigaretesLabel?.textColor = .white
            cigaretesLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            view.addSubview(cigaretesLabel!)
            cigaretesLabel?.snp.makeConstraints({ make in
                make.top.equalTo(imageView.snp.bottom).inset(-5)
                make.centerX.equalToSuperview()
            })
            let button = UIButton()
            button.setTitle("Open", for: .normal)
            button.tag = 1
            button.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 0.24)
            button.layer.cornerRadius = 17
            button.setTitleColor(.white, for: .normal)
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(34)
                make.width.equalTo(66)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(20)
            }
            button.addTarget(self, action: #selector(openBadHabits(sender:)), for: .touchUpInside)
            
        } else {
            
            imageView.image = UIImage.glass
            
            
            wineLabel = UILabel()
            wineLabel?.text = "0 glasses"
            wineLabel?.textColor = .white
            wineLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            view.addSubview(wineLabel!)
            wineLabel?.snp.makeConstraints({ make in
                make.top.equalTo(imageView.snp.bottom).inset(-5)
                make.centerX.equalToSuperview()
            })
            
            let button = UIButton()
            button.setTitle("Open", for: .normal)
            button.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 0.24)
            button.layer.cornerRadius = 17
            button.tag = 2
            button.setTitleColor(.white, for: .normal)
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(34)
                make.width.equalTo(66)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(20)
            }
            button.addTarget(self, action: #selector(openBadHabits(sender:)), for: .touchUpInside)
        }
        
        return view
    }

}


extension HomeViewController: HomeViewControllerDelegate {
    
    func reloadInfo() {
        
        var cigar = 0
        
        if cigarArr.count > 0 {
            for i in cigarArr {
                cigar += i.number
            }
            cigaretesLabel?.text = "\(cigar) cigarette"
        } else {
            cigaretesLabel?.text = "0 cigarette"
        }
        
        var wine = 0
        if alcoArr.count > 0 {
            for i in alcoArr {
                wine += i.number
            }
            wineLabel?.text = "\(wine) glasses"
        } else {
            wineLabel?.text = "0 glasses"
        }
        
    }
    
    //cigaretesLabel?.text = "0 cigarette"
    
    
    func openVC(selected: Int) {
        let vc = AddBadHabitsViewController()
        vc.delegate = self
        
        if selected == 1 {
            vc.selectedHabits = "Cigarette"
            vc.title = "Cigarette"
        } else {
            vc.selectedHabits = "Alcohol"
            vc.title = "Alcohol"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //ДОДЕЛАТЬ РЕДАКТИРОВАНИЕ
    func reloadDiagramm(allDays: Int, totalDays: Int) {
        progress = [allDays, totalDays]
        fillProgress()
        
        UserDefaults.standard.setValue(progress, forKey: "Home")
    }
}
