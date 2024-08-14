//
//  EditAccountViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 14.08.2024.
//

import UIKit

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    weak var delegate: AccountViewControllerDelegate?
    
    var name, exp: String?
    var image: UIImage?
    
    
    var imageView: UIImageView?
    var nameTextField, expTextField: UITextField?
    var saveButton: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        createInterface()
        checkIsEdit()
    }
    
    func checkIsEdit() {
        if name != nil, exp != nil, image != nil {
            nameTextField?.text = name
            expTextField?.text = exp
            imageView?.image = image
            checkFill() 
        }
    }
    
    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Edit profile"
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
        
        imageView = {
            let imageView = UIImageView(image: .noImageView)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 65
            imageView.isUserInteractionEnabled = true
            imageView.backgroundColor = .white.withAlphaComponent(0.05)
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(130)
            make.centerX.equalToSuperview()
            make.top.equalTo(exitButton.snp.bottom).inset(-30)
        })
        let gestureSelectImage = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gestureSelectImage)
        
        let nameLabel = createLabel(text: "Name")
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-30)
        }
        
        nameTextField = createTextField()
        view.addSubview(nameTextField!)
        nameTextField!.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(56)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
        }
        
        let expLabel = createLabel(text: "Experience")
        view.addSubview(expLabel)
        expLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-20)
        }
        
        expTextField = createTextField()
        expTextField?.keyboardType = .numberPad
        view.addSubview(expTextField!)
        expTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(56)
            make.top.equalTo(expLabel.snp.bottom).inset(-10)
        })
        
        saveButton = {
            let button = UIButton()
            button.backgroundColor = .white.withAlphaComponent(0.3)
            button.layer.cornerRadius = 12
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.black, for: .normal)
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
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(hideKBGesture)
        
        
    }
    
    @objc func save() {
        
        let user = User(name: nameTextField?.text ?? "", exp: expTextField?.text ?? "", image: imageView?.image?.jpegData(compressionQuality: 0.5) ?? Data())
        
        
        do {
            let data = try JSONEncoder().encode(user) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.reload(data: user)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("user.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    @objc func hideKB() {
        checkFill()
        view.endEditing(true)
    }
    
    @objc func exit() {
        delegate = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
        textField.delegate = self
        return textField
    }
    
    func checkFill() {
        if nameTextField?.text?.count ?? 0 > 0, expTextField?.text?.count ?? 0 > 0 {
            saveButton?.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
            saveButton?.isEnabled = true
        } else {
            saveButton?.backgroundColor = .white.withAlphaComponent(0.3)
            saveButton?.isEnabled = false
        }
    }
    
}


extension EditAccountViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkFill()
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkFill()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkFill()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFill()
    }
    
    
}
