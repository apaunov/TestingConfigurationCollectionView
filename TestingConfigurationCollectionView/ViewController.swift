//
//  ViewController.swift
//  TestingConfigurationCollectionView
//
//  Created by Andrey Paunov on 2020-10-05.
//

import UIKit

class ViewController: UICollectionViewController {
    private lazy var dataSource = makeDataSource()
    private var continents = Continent.allContinents
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Continent, Country>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Continent, Country>
    
    // MARK: - Overriding Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        applySnapshot(animatingDifferences: false)
    }

    // MARK: - Helper functions
    
    private func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary
            configuration.backgroundColor = .systemPurple
            configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
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
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20.0))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        })
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
            let continent = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            supplementaryView.titleLabel.text = continent.name
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
        snapshot.appendSections(continents)

        continents.forEach { continent in
            snapshot.appendItems(continent.countries, toSection: continent)
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
