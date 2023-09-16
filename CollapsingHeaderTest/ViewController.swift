//
//  ViewController.swift
//  CollapsingHeaderTest
//
//  Created by 福田正知 on 2023/09/16.
//

import UIKit

class ViewController: UIViewController {
    
    let collapsingHeaderViewController = CollapsingHeaderViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0.1, green: 0.5, blue: 0.5, alpha: 1))
        // Do any additional setup after loading the view.
        Task {
            try await Task.sleep(nanoseconds: 500 * 1_000 * 1_000)
            collapsingHeaderViewController.modalPresentationStyle = .fullScreen
            self.present(collapsingHeaderViewController, animated: true)
        }
    }

}

class CollapsingHeaderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1))
        
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        topView.backgroundColor = UIColor(cgColor: CGColor(red: 0.8, green: 0.8, blue: 0.3, alpha: 1))
        view.addSubview(topView)
        
        let label = UILabel()
        label.text = "test label"
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: topView.widthAnchor),
            label.heightAnchor.constraint(equalTo: topView.heightAnchor)
        ])
        
        let tabView = UIStackView()
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.distribution = .fillEqually
        tabView.alignment = .fill
        tabView.axis = .horizontal
        tabView.spacing = 0.0
        tabView.backgroundColor = UIColor(cgColor: CGColor(red: 0.7, green: 0.3, blue: 0.6, alpha: 1))
        view.addSubview(tabView)
        tabView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tabView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tabView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        tabView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let button1 = TabButtonView(frame: UIView().frame)
        button1.setup(title: "button1", tag: 1)
        let button2 = TabButtonView(frame: UIView().frame)
        button2.setup(title: "button2", tag: 2)
        let button3 = TabButtonView(frame: UIView().frame)
        button3.setup(title: "button3", tag: 3)
        tabView.addArrangedSubview(button1)
        tabView.addArrangedSubview(button2)
        tabView.addArrangedSubview(button3)
        
        // UICollectionViewを使ったパターン
//        setupCollectionView(tabView: tabView)
        
        // UIPageViewControllerを使ったパターン
    }
    
    /// UICollectionViewを試すパターン
    /// - Parameters:
    ///   - tabView: 上を合わせるtabView
    private func setupCollectionView(tabView: UIStackView) {
        // UICollectionViewを試すパターン
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .systemCyan.withAlphaComponent(0.8)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

// MARK: UICollection
extension CollapsingHeaderViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        return cell
    }
}

extension CollapsingHeaderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
}

@IBDesignable
class TabButtonView: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(title: String, tag: Int) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        self.tag = tag
        self.addAction(UIAction(handler: { _ in
            print("Tap Button \(self.tag)")
        }), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = CGColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 1)
        layer.borderWidth = 1.0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
