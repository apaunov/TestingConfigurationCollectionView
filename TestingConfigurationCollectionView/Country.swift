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
    var continent: Continent?
    
    init(name: String, capital: String?, continent: Continent?) {
        self.name = name
        self.capital = capital
        self.continent = continent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id
    }
}
