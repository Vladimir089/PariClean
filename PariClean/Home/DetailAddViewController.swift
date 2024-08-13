//
//  DetailAddViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 13.08.2024.
//

import UIKit

class DetailAddViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
    }
    

    func createInterface() {
        
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.4)
        topView.layer.cornerRadius = 2.5
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        let leftLabel = UILabel()
        leftLabel.text = "Add"
        leftLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        leftLabel.textColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
        view.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(topView.snp.bottom).inset(-15)
        }
        
        let closeButton: UIButton = {
            let button = UIButton()
            button.setImage(.xmark.resize(targetSize: CGSize(width: 15, height: 15)), for: .normal)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 12
            return button
        }()
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(leftLabel)
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let cigarButton = createButt(tag: 1)
        view.addSubview(cigarButton)
        cigarButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(74)
            make.top.equalTo(closeButton.snp.bottom).inset(-30)
        }
        
        let wineButton = createButt(tag: 2)
        view.addSubview(wineButton)
        wineButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(74)
            make.top.equalTo(cigarButton.snp.bottom).inset(-15)
        }
        
        
        
    }
    
    
    
    func createButt(tag: Int) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.05)
        button.layer.cornerRadius = 20
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(41)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).inset(-15)
        }
        
        
        let imageViewArrow = UIImageView(image: .arrow)
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageViewArrow)
        imageViewArrow.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(13)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        if tag == 1 {
            imageView.image = .cigar.resize(targetSize: CGSize(width: 41, height: 35))
            label.text = "Cigarette"
            button.tag = 1
        } else {
            imageView.image = .glass.resize(targetSize: CGSize(width: 41, height: 35))
            label.text = "Glasses"
            button.tag = 2
        }
        
        button.addTarget(self, action: #selector(openDetail(sender:)), for: .touchUpInside)
        
        return button
    }
    
    
    @objc func openDetail(sender: UIButton) {
        close()
        delegate?.openVC(selected: sender.tag)
    }
    
    
    @objc func close() {
        self.dismiss(animated: true)
    }

}
