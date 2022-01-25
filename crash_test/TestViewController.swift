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
//    lazy var coordinator: NoxVoiceRoomCoordinator = {
//        return NoxVoiceRoomCoordinator(tableView)
//    }()
    let button = UIButton()
    
    var coordinator: TestCoordinator!
    var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
        view.addSubview(tableView)
        
        let screen = UIScreen.main.bounds
        let wh: CGFloat = 50
        button.frame = CGRect(origin: CGPoint(x: screen.width/2 - wh/2, y: screen.height/2 - wh/2), size: CGSize(width: wh, height: wh))
        button.setTitle("B", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(test(_:)), for: .touchUpInside)
        view.addSubview(button)
        coordinator = TestCoordinator(tableView)
    }
    
    @objc func test(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        coordinator.refresh()
//        print("viewcontroller deinit")
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
        self.tableView = tableView
        tableView.register(NoxTestCell.self, forCellReuseIdentifier: "cell")
        print("------coordinator init")
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private override init() {
        super.init()
    }
    
    /// 刷新CollectionView成员数据
    public func refresh() {
        queue.async(execute: DispatchWorkItem(block: { [weak self] in
            self?.person.name = "222"
            var persons: [Person] = [Person(name: "1112222")]
            if let person = self?.person {
                persons.append(person)
            }
            self?.sections.accept([NoxAnimatableSecionModel(model: "1", items: persons)])
        }))
    }
    
    deinit {
//        assert(Thread.isMainThread, "deinit not on the main thread -- coodinator")
        print("coordinator deinit")
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
    var name: String?
    let printer = DeallocPrinter()
}

class DeallocPrinter {
    deinit {
//        assert(Thread.isMainThread, "释放不在主线程")
        print("Person deinit")
    }
}

// MARK: - Rx Animatable
extension Person: IdentifiableType, Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs == rhs
    }
    
    typealias Identity = String
    var identity: String {
        UUID().uuidString
    }
}

class NoxTestCell: UITableViewCell {
    
}
