//
//  JSONHandler.swift
//  QuimicaAR
//
//  Created by João Henrique Andrade on 14/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
class JSONHandler {
    
    static let shared = JSONHandler()
    private init() {}
    
    var elementos: [AtomoCodable] = []
    
    func readAtomos() {
        guard let fileUrl = Bundle.main.url(forResource: "Atomos", withExtension: "json") else {
            print("File could not be located at the given url")
            return
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            elementos = try JSONDecoder().decode([AtomoCodable].self, from: data)
        } catch {
            print("Error: \(error)")
        }
    }
}
