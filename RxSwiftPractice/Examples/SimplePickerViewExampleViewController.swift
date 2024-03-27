//
//  SimplePickerViewExampleViewController.swift
//  RxSwiftPractice
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


// 질문
// itemTitles에 String 형태로 들어갔는데 modelSelected에서 Int 타입으로 값을 받아올 수 있는 이유가 뭘까요?
class SimplePickerViewExampleViewController: UIViewController {
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 1: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor:
                                                UIColor.systemRed,
                                            NSAttributedString.Key.underlineStyle:
                                                NSUnderlineStyle.double.rawValue
                                          ])
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print("models selected 3: \(models)")
            })
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        [pickerView1, pickerView2, pickerView3].forEach {
            view.addSubview($0)
        }
        pickerView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(170)
        }
        pickerView2.snp.makeConstraints { make in
            make.top.equalTo(pickerView1.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(170)
        }
        pickerView3.snp.makeConstraints { make in
            make.top.equalTo(pickerView2.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.greaterThanOrEqualToSuperview()
            make.height.equalTo(170)
        }
        
    }
    
}
