//
//  TestViewController.swift
//  crash_test
//
//  Created by adam on 2022/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TestViewController: UIViewController {
    var coordinator: TestCoordinator!
    var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
        view.addSubview(tableView)
        coordinator = TestCoordinator(tableView)
    }
    
    @objc func test(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        coordinator.refresh()
    }
}

final class TestCoordinator: NSObject {
    let disposeBag = DisposeBag()
    private typealias NoxAnimatableSecionModel = AnimatableSectionModel<String, Person>
    private var sections: BehaviorRelay<[NoxAnimatableSecionModel]> = BehaviorRelay(value: [])
    private let queue: DispatchQueue = DispatchQueue(label: "com.test.room.parse", qos: .utility)
    private var person: Person = Person(name: "11")
    
    weak var tableView: UITableView!
    convenience init(_ tableView: UITableView) {
        self.init()
        print("coordinator init")
        self.tableView = tableView
        tableView.register(NoxTestCell.self, forCellReuseIdentifier: "cell")
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private override init() {super.init()}
    
    public func refresh() {
//        let secions = self.sections
//        var person = self.person
//        queue.async(execute: DispatchWorkItem(block: {
//            person.name = "222"
//            var persons: [Person] = [Person(name: "1112222")]
//            persons.append(person)
////            DispatchQueue.main.async {
//            secions.accept([NoxAnimatableSecionModel(model: "1", items: persons)])
////            }
//        }))
        queue.async(execute: DispatchWorkItem(block: { [weak self] in
//            DispatchQueue.main.async {
                self?.person.name = "222"
                var persons: [Person] = [Person(name: "11122223"),Person(name: "11122221"),Person(name: "11122224"),Person(name: "11122225")]
                if let person = self?.person {
                    persons.append(person)
                }
                self?.sections.accept([NoxAnimatableSecionModel(model: "1", items: persons)])
//            }
        }))
    }
    
    deinit {
        print("coordinator deinit \(Thread.current)")
    }
}

extension TestCoordinator {
    private func dataSource() -> RxTableViewSectionedAnimatedDataSource<NoxAnimatableSecionModel> {
        return RxTableViewSectionedAnimatedDataSource<NoxAnimatableSecionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic),
            configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "\(indexPath.row)"
                return cell
            })
    }
}

struct Person {
    var id: String = UUID().uuidString
    var name: String
    let printer = DeallocPrinter(name: "person")
}

class DeallocPrinter: Hashable, Encodable {
    let name: String
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) deinit \(Thread.current)")
    }
    
    static func == (lhs: DeallocPrinter, rhs: DeallocPrinter) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

// MARK: - Rx Animatable
extension Person: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        id
    }
}



class NoxTestCell: UITableViewCell {
    
}
