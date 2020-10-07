//
//  Continent.swift
//  TestingConfigurationCollectionView
//
//  Created by Andrey Paunov on 2020-10-06.
//

import UIKit

class Continent: Hashable {
    var id = UUID()
    var name: String
    var countries: [Country]
    
    init(title: String, countries: [Country]) {
        self.name = title
        self.countries = countries
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Continent, rhs: Continent) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Continent {
    static var allContinents: [Continent] = [
        Continent(title: "Asia", countries: [
            Country(name: "China", capital: "Beijing"),
            Country(name: "India", capital: "New Delhi"),
            Country(name: "Nepal", capital: "Kathmandu")
        ]),
        Continent(title: "Europe", countries: [
            Country(name: "Romania", capital: "Bucharest"),
            Country(name: "Bulgaria", capital: "Sofia")
        ]),
        Continent(title: "North America", countries: [
            Country(name: "Canada", capital: "Ottawa"),
            Country(name: "USA", capital: "Washington"),
        ])
    ]
}
