//
//  ViewController.swift
//  TextViewHide
//
//  Created by 위대연 on 2022/02/19.
//

import UIKit

class ViewController: UIViewController {
    var textField: UITextField!
    var showButton: UIButton!
    private var hiddenText: String = "" {
        didSet{
            print("hiddenText: " + hiddenText)
        }
    }
    var isShowMode = false
    
    let secretChar = "*"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField = createTextField()
        showButton = createShowButton()

        view.addSubview(textField)
        view.addSubview(showButton)
        
        let viewGuide = view.safeAreaLayoutGuide
        textField.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        [
            textField.topAnchor.constraint(equalTo: viewGuide.topAnchor, constant: 30),
            textField.leadingAnchor.constraint(equalTo: viewGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: viewGuide.trailingAnchor,constant: -16),
            textField.heightAnchor.constraint(equalToConstant: textField.frame.height),
            
            showButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            showButton.trailingAnchor.constraint(equalTo: viewGuide.trailingAnchor,constant: -16),
            showButton.heightAnchor.constraint(equalToConstant: textField.frame.height),
            showButton.widthAnchor.constraint(equalToConstant: 100)
        ].forEach { $0.isActive = true }
    }
    
    func createTextField() -> UITextField {
        let textFieldSize = CGSize(width: 0, height: 35)
        let textField = UITextField(frame: CGRect(origin: .zero, size: textFieldSize))
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.textContentType = .password
        textField.placeholder = "password"
        textField.keyboardType = .asciiCapable
        textField.isSelected = false
        
        textField.addTarget(self, action: #selector(textFieldEditingChangedAction(_:)), for: .editingChanged)
        return textField
    }

    func createShowButton() -> UIButton {
        let showButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 35)))
        showButton.setTitle("Set Show", for: .normal)
        showButton.setTitleColor(.systemBlue, for: .normal)
        showButton.backgroundColor = .clear
        showButton.setBackgroundImage(nil, for: .normal)
        showButton.layer.borderWidth = 1
        showButton.layer.borderColor = UIColor.systemBlue.cgColor
        showButton.layer.cornerRadius = 10
        showButton.addTarget(self, action: #selector(showButtonAction(_:)), for: .touchUpInside)
        
        return showButton
    }
    
    @objc func showButtonAction(_ sender: UIButton) {
        if ( sender.titleLabel?.text == "Set Show") {
            self.isShowMode = true
            sender.setTitle("Set Hide", for: .normal)
            sender.layer.borderColor = UIColor.clear.cgColor
            sender.backgroundColor = .darkGray
            sender.setTitleColor(.white, for: .normal)
            
            self.textField.text = hiddenText
            
        } else {
            self.isShowMode = false
            sender.setTitle("Set Show", for: .normal)
            sender.setTitleColor(.systemBlue, for: .normal)
            sender.backgroundColor = .clear
            sender.layer.borderColor = UIColor.systemBlue.cgColor
            
            textField.text = ""
            hiddenText.forEach { _ in
                textField.text! += secretChar
            }
        }
    }
    
    @objc func textFieldEditingChangedAction(_ textField: UITextField) {
        guard let last = textField.text?.last else {
            hiddenText = ""
            return
        }
        
        if textField.text?.count ?? 0 > hiddenText.count {
            if (!isShowMode) {
                textField.text?.removeLast()
                textField.text! += secretChar
            }
            hiddenText += String(last)
        } else {
            hiddenText.removeLast()
        }
    }
}
