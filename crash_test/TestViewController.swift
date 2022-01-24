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
    lazy var coordinator: NoxVoiceRoomCoordinator = {
        return NoxVoiceRoomCoordinator()
    }()
    
//    var coordinator: NoxVoiceRoomCoordinator!
    var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
        view.addSubview(tableView)
//        coordinator = NoxVoiceRoomCoordinator(tableView)
//        coordinator.testBlock = { [weak self] in
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                self?.coordinator = nil
//                print("set nil to coordinator")
//            })
//        }
//        coordinator.refresh()
        
    }
    
    deinit {
        coordinator.refresh()
//        print("viewcontroller deinit")
    }
}

final class NoxVoiceRoomCoordinator: NSObject {
    let disposeBag = DisposeBag()
    private typealias NoxAnimatableSecionModel = AnimatableSectionModel<String, Person>
    private var sections: BehaviorRelay<[NoxAnimatableSecionModel]> = BehaviorRelay(value: [])
    private let concurrentQueue = DispatchQueue(label: "concurrent", attributes: [.concurrent])
    private let queue: DispatchQueue = DispatchQueue(label: "com.noxgroup.onmic.room.parse", qos: .utility)
    private lazy var micPlaceholder = "123"
    private var person: Person = Person(name: "11")
    private var item: DispatchWorkItem?
    
    var testBlock: (() -> Void)?
    
    var tableView: UITableView!
    convenience init(_ tableView: UITableView) {
        self.init()
        self.tableView = tableView
        tableView.register(NoxTestCell.self, forCellReuseIdentifier: "cell")
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    override init() {
        super.init()
    }
    
    /// 刷新CollectionView成员数据
    public func refresh() {
//        concurrentQueue.asyncAfter(deadline: .now()) { [weak self] in
//            DispatchQueue.main.async {
//                self?.testBlock?()
//            }
//        }
//        concurrentQueue.asyncAfter(deadline: .now() + .milliseconds(5)) { [weak self] in
//            self?.micPlaceholder = "345"
//            print("set micPlaceholder")
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) { [weak self] in
//            self?.testBlock?()
//        }
        if let item = item, !item.isCancelled {
            item.cancel()
        }
        item = DispatchWorkItem(block: { [weak self] in
            self?.testBlock?()
            self?.person.name = "222"
            self?.sections.accept([NoxAnimatableSecionModel(model: "1", items: [Person(name: "1112222")])])
            print("set micPlaceholder")
        })
        if let item = item {
            queue.async(execute: item)
        }
    }
    
    deinit {
        item?.cancel()
//        assert(Thread.isMainThread, "释放不在主线程 coodinator")
        print("coordinator deinit")
    }
}

extension NoxVoiceRoomCoordinator {
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
