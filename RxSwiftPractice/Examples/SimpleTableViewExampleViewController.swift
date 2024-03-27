//
//  SimpleTableViewExampleViewController.swift
//  RxSwiftPractice
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleTableViewExampleViewController: ViewController, UITableViewDelegate{
    let tableView = UITableView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        tableView.delegate = self
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.present(ViewController(), animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.present(ViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
