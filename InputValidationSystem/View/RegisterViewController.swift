//
//  RegisterViewController.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    private let emailTextField = RegisterViewController.createTextField(placeholder: "Email", isSecure: false)
    private let usernameTextField = RegisterViewController.createTextField(placeholder: "Kullanıcı Adı", isSecure: false)
    private let phoneTextField = RegisterViewController.createTextField(placeholder: "Telefon Numarası", isSecure: false)
    private let passwordTextField = RegisterViewController.createTextField(placeholder: "Şifre", isSecure: true)
    private let confirmPasswordTextField = RegisterViewController.createTextField(placeholder: "Şifre Tekrar", isSecure: true)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var viewModel = RegisterViewModel()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Kayıt Ol"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.buttonSize = .large
        
        let button = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Kayıt Ol Butonuna Tıklandı!")
        }))
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.addTarget(self, action: #selector(selectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        [usernameTextField, emailTextField, phoneTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(addPhotoButton)

        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            emailTextField,
            phoneTextField,
            passwordTextField,
            confirmPasswordTextField,
            registerButton,
            messageLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        contentView.addSubview(stackView)
        
        [scrollView, contentView, profileImageView, addPhotoButton, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            addPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -8),
            addPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -8),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 32),
            addPhotoButton.heightAnchor.constraint(equalTo: addPhotoButton.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
        
        profileImageView.layer.cornerRadius = 100
        profileImageView.clipsToBounds = true
        
        registerForKeyboardNotifications()
    }
    
    @objc private func selectProfilePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @objc private func registerButtonTapped() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        viewModel.username = usernameTextField.text ?? ""
        viewModel.phoneNumber = phoneTextField.text ?? ""
        
        debugPrint("Email: \(viewModel.email), Password: \(viewModel.password), Confirm: \(viewModel.confirmPassword), Username: \(viewModel.username), Phone: \(viewModel.phoneNumber)")
        
        if let validationError = viewModel.validateFields() {
            showError(validationError)
        } else {
            messageLabel.text = "Kayıt Başarılı!"
            messageLabel.textColor = .systemGreen
        }
    }
    
    private func showError(_ error: ValidationError) {
        messageLabel.text = "\(error.title): \(error.message ?? "")"
        messageLabel.textColor = .systemRed
    }
    
    static func createTextField(placeholder: String, isSecure: Bool) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.autocorrectionType = .no // Otomatik düzeltme devre dışı bırakılır.
        textField.spellCheckingType = .no // Yazım denetimi kapatılır.
        return textField
    }
    
    private func configureTextFieldEvents() {
        [usernameTextField, emailTextField, phoneTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        if let activeTextField = view.currentFirstResponder as? UIView {
            let visibleFrame = activeTextField.convert(activeTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(visibleFrame, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
}

extension UIView {
    var currentFirstResponder: UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let responder = subview.currentFirstResponder {
                return responder
            }
        }
        return nil
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc internal func textFieldDidBeginEditing(_ textField: UITextField) {
        let visibleFrame = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(visibleFrame, animated: true)
    }
}
