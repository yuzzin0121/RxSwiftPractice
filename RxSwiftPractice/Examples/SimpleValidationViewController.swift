//
//  SimpleValidationViewController.swift
//  RxSwiftPractice
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

// .share(replay: 1)는 뭐하는 걸까
class SimpleValidationViewController: UIViewController {
    let userNameLabel = UILabel()
    let userNameTextField = UITextField()
    let userNameMessageLabel = UILabel()
    
    let passwdLabel = UILabel()
    let passwdTextField = UITextField()
    let passwdMessageLabel = UILabel()
    
    let doSomethingButton = UIButton()
    
    
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        userNameMessageLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwdMessageLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = userNameTextField.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwdValid = passwdTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwdValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: passwdTextField.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: userNameTextField.rx.isHidden)
            .disposed(by: disposeBag)

        passwdValid
            .bind(to: passwdTextField.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        [userNameLabel, userNameTextField, userNameMessageLabel, passwdLabel,
         passwdTextField, passwdMessageLabel, doSomethingButton].forEach {
            view.addSubview($0)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(14)
        }
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        userNameMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(userNameTextField)
            make.height.equalTo(14)
        }
        
        passwdLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameMessageLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(14)
        }
        passwdTextField.snp.makeConstraints { make in
            make.top.equalTo(passwdLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(userNameTextField)
            make.height.equalTo(44)
        }
        passwdMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(passwdTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(userNameTextField)
            make.height.equalTo(14)
        }
        doSomethingButton.snp.makeConstraints { make in
            make.top.equalTo(passwdMessageLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(passwdMessageLabel)
            make.height.equalTo(50)
        }
        
        userNameLabel.text = "Username"
        passwdLabel.text = "Password"
        userNameTextField.backgroundColor = .systemGray6
        passwdTextField.backgroundColor = .systemGray6
        
        userNameMessageLabel.textColor = .systemRed
        passwdMessageLabel.textColor = .systemRed
        
        doSomethingButton.backgroundColor = .systemBlue
        doSomethingButton.setTitleColor(.white, for: .normal)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
