//
//  EditDiagramViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//

import UIKit

class EditDiagramViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    var topTextField, botTextField: UITextField?
    var saveButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
    }
    

    func createInterface() {
        
        let topView = UIView()
        topView.backgroundColor = .white.withAlphaComponent(0.5)
        topView.layer.cornerRadius = 2.5
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        
        let topLabel = UILabel()
        topLabel.text = "Edit bad habits"
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topLabel.textColor = .white
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).inset(-15)
        }
        
        let button = UIButton()
        button.setImage(.xmark.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal) //КНОПКА ЗАКРЫТИЯ
        button.tintColor = .white.withAlphaComponent(0.5)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.centerY.equalTo(topLabel)
            make.left.equalToSuperview()
        }
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gesture)
        
        
        let topLabelName = createLabel(text: "Days without bad habits")
        view.addSubview(topLabelName)
        topLabelName.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(topLabel.snp.bottom).inset(-50)
        }
        
        topTextField = createTextField()
        view.addSubview(topTextField!)
        topTextField?.snp.makeConstraints({ make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabelName.snp.bottom).inset(-15)
        })
        
        let botLabel = createLabel(text: "Total days")
        view.addSubview(botLabel)
        botLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(topTextField!.snp.bottom).inset(-25)
        }
        botTextField = createTextField()
        view.addSubview(botTextField!)
        botTextField?.snp.makeConstraints({ make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(botLabel.snp.bottom).inset(-15)
        })
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 12
            button.backgroundColor = .white.withAlphaComponent(0.3)
            button.isEnabled = false
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Enter"
        textField.backgroundColor = .white.withAlphaComponent(0.12)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.layer.borderColor = UIColor.white.withAlphaComponent(0.05).cgColor
        textField.layer.borderWidth = 0.33
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }
    
    @objc func save() {
        let topInt: Int = Int(topTextField?.text ?? "0") ?? 0
        let botInt: Int = Int(botTextField?.text ?? "31") ?? 0
        
        delegate?.reloadDiagramm(allDays: topInt, totalDays: botInt)
        self.view.endEditing(true)
        close()
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    @objc func hideKB() {
        checkFill()
        view.endEditing(true)
    }
    
    func checkFill() {
        if topTextField?.text?.count ?? 0 > 0 , botTextField?.text?.count ?? 0 > 0 {
            saveButton?.isEnabled = true
            saveButton?.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = .white.withAlphaComponent(0.3)
        }
    }
    
}


extension EditDiagramViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkFill()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkFill()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkFill()
    }
}
