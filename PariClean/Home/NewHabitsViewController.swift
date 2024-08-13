//
//  NewHabitsViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 13.08.2024.
//

import UIKit

class NewHabitsViewController: UIViewController {
    
    var numbTextField, reasonTextField, timeTextField: UITextField?
    var saveButton: UIButton?
    
    var isEdit = false
    var index = 0 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    weak var mainDelegate: AddBadHabitsViewControllerDelegate?
    var habits = "Cigarette"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
    }
    
    func createInterface() {
        
        let topLabel = UILabel()
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        if habits == "Cigarette" {
            topLabel.text = "Add cigarette"
        } else {
            topLabel.text = "Add alcohol"
        }
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let closeBut: UIButton = {
            let button = UIButton()
            button.setImage(.xmark.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 12
            return button
        }()
        view.addSubview(closeBut)
        closeBut.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.centerY.equalTo(topLabel)
            make.left.equalToSuperview().inset(15)
        }
        closeBut.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let numbLabel = createLabels()
        if habits == "Cigarette" {
            numbLabel.text = "Number of cigarettes"
        } else {
            numbLabel.text = "Number of glass"
        }
        view.addSubview(numbLabel)
        numbLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(closeBut.snp.bottom).inset(-25)
        }
        
        numbTextField = createTextField()
        numbTextField?.keyboardType = .numberPad
        view.addSubview(numbTextField!)
        numbTextField?.snp.makeConstraints({ make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(numbLabel.snp.bottom).inset(-10)
        })
        
        let reasonLabel = createLabels()
        reasonLabel.text = "Reason"
        view.addSubview(reasonLabel)
        reasonLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(numbTextField!.snp.bottom).inset(-20)
        }
        reasonTextField = createTextField()
        view.addSubview(reasonTextField!)
        reasonTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(56)
            make.top.equalTo(reasonLabel.snp.bottom).inset(-10)
        })
        
        let timeLabel = createLabels()
        timeLabel.text = "Time"
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(reasonTextField!.snp.bottom).inset(-20)
        }
        timeTextField = createTextField()
        view.addSubview(timeTextField!)
        timeTextField?.snp.makeConstraints({ make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(timeLabel.snp.bottom).inset(-10)
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
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gesture)
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        checkISEdit()
    }
    
    
    func checkISEdit() {
        if isEdit == true {
            if habits == "Cigarette"  {
                numbTextField?.text = "\(cigarArr[index].number)"
                reasonTextField?.text = cigarArr[index].reason
                timeTextField?.text = cigarArr[index].time
            } else {
                numbTextField?.text = "\(alcoArr[index].number)"
                reasonTextField?.text = alcoArr[index].reason
                timeTextField?.text = alcoArr[index].time
            }
            checkTextFields()
            
        }
    }
    
    @objc func save() {
        let number = Int(numbTextField?.text ?? "1") ?? 1
        let reason = reasonTextField?.text ?? " "
        let time = timeTextField?.text ?? " "
        
        let day = dateFordetter(date: Date()).lowercased()
        
        
        let all = AlcoSigar(number: number, reason: reason, time: time, day: day)
        
        if isEdit == false {
            if habits == "Cigarette" {
                cigarArr.append(all)
                saveCigarArray(cigarArr)
            } else {
                alcoArr.append(all)
                saveAlcoArray(alcoArr)
                
            }
        } else {
            if habits == "Cigarette" {
                cigarArr[index] = all
                saveCigarArray(cigarArr)
            } else {
                alcoArr[index] = all
                saveAlcoArray(alcoArr)
                
            }
        }
        
        
        
        mainDelegate?.reloadCollection()
        self.navigationController?.popViewController(animated: true)
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
    
    
    
    func dateFordetter(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "eee"
        return dateFormater.string(from: date)
    }
    
    func checkTextFields() {
        if numbTextField?.text?.count ?? 0 > 0, reasonTextField?.text?.count ?? 0 > 0, timeTextField?.text?.count ?? 0 > 0 {
            saveButton?.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
            saveButton?.isEnabled = true
        } else {
            saveButton?.backgroundColor = .white.withAlphaComponent(0.3)
            saveButton?.isEnabled = false
        }
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
        textField.delegate = self
        return textField
    }
    
    func createLabels() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func hideKB() {
        checkTextFields()
        view.endEditing(true)
    }
    

}


extension NewHabitsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKB()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkTextFields()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTextFields()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkTextFields()
        return true
    }
}
