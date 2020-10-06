//
//  ViewController.swift
//  TestingConfigurationCollectionView
//
//  Created by Andrey Paunov on 2020-10-05.
//

import UIKit

class ViewController: UICollectionViewController {
    private lazy var dataSource = makeDataSource()
    private var sections = Continent.allCases
    
    private var countries = [Country]() {
        didSet {
            applySnapshot()
        }
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Continent, Country>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Continent, Country>
    
    // MARK: - Overriding Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        configureLayout()
        applySnapshot(animatingDifferences: false)
    }

    // MARK: - Helper functions
    
    private func initializeData() {
        self.countries.append(Country(name: "Canada", capital: "Ottawa", continent: .northAmerica))
        self.countries.append(Country(name: "China", capital: "Beijing", continent: .asia))
        self.countries.append(Country(name: "India", capital: "New Delhi", continent: .asia))
        self.countries.append(Country(name: "Nepal", capital: "Kathmandu", continent: .asia))
        self.countries.append(Country(name: "Romania", capital: "Bucharest", continent: .europe))
        self.countries.append(Country(name: "USA", capital: "Washington", continent: .northAmerica))
    }
    
    private func configureLayout() {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        config.backgroundColor = .systemPurple
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard self != nil else {
                return nil
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, handler) in
                NSLog("==== \(indexPath.row) editAction clicked")
                
                handler(true)
            }
            
            editAction.backgroundColor = .systemTeal
                
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, handler) in
                NSLog("==== \(indexPath.row) deleteAction clicked")
                
                handler(true)
            }
                
            deleteAction.backgroundColor = .red
         
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func makeDataSource() -> DataSource {
        // iOS 14+
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Country> { cell, indexPath, country in
            var content = cell.defaultContentConfiguration()
            content.text = country.name
            content.secondaryText = country.capital
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            content.image = UIImage(systemName: "globe")
            content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)
            
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
            cell.tintColor = .systemPurple
        }
        
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, country) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: country)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderReusableView>(elementKind: "Header") { (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = string
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            if elementKind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            } else {
                return nil
            }
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)

        countries.forEach { country in
            snapshot.appendItems([country], toSection: country.continent)
        }

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let country = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        NSLog("Country clicked: \(country.name)")
    }
}
