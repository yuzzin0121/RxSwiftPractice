//
//  NumbersViewController.swift
//  RxSwiftPractice
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {
    let number1 = UITextField()
    let number2 = UITextField()
    let number3 = UITextField()
    let plusLabel = UILabel()
    
    let separatorView = UIView()
    
    let resultLabel = UILabel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { value1, value2, value3 -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
        }
        .map { $0.description }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        [number1,number2, number3, separatorView, plusLabel, resultLabel].forEach {
            view.addSubview($0)
        }
        
        number1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(number3)
            make.trailing.equalTo(number3.snp.leading).offset(-6)
            make.height.equalTo(14)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(8)
            make.leading.equalTo(plusLabel)
            make.trailing.equalTo(number3)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(separatorView)
            make.height.equalTo(14)
        }
        
        number1.backgroundColor = .systemGray6
        number2.backgroundColor = .systemGray6
        number3.backgroundColor = .systemGray6
        
        number1.textAlignment = .right
        number2.textAlignment = .right
        number3.textAlignment = .right
        
        plusLabel.text = "+"
        separatorView.backgroundColor = .gray
        resultLabel.text = "\(0)"
        resultLabel.textAlignment = .right
    }

}
