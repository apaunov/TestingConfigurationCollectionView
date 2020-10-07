//
//  Country.swift
//  TestingConfigurationCollectionView
//
//  Created by Andrey Paunov on 2020-10-05.
//

import UIKit

class Country: Hashable {
    var id = UUID()
    var name: String
    var capital: String?
    
    init(name: String, capital: String?) {
        self.name = name
        self.capital = capital
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id
    }
}
