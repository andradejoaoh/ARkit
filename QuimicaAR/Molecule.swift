//
//  Molecule.swift
//  QuimicaAR
//
//  Created by Pedro Henrique Guedes Silveira on 17/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation


class Molecule {
    
    public var atoms: [Atomo]
    var id = String()
    
    init(atom: Atomo) {
        self.atoms = [atom]
        self.id = UUID().uuidString
    }
    
    
   func addAtom(atom: Atomo) {
        if atoms.count == 0 {
            atoms.append(atom)
        } else {
            for i in atoms {
                if i.id != atom.id {
                    atoms.append(atom)
                }
            }
        }
    }
    
    func addConnection(atomA: Atomo, AtomB: Atomo) {
        guard let firstAtom = atomA.checkIfIsConnected(atom: AtomB) else {return}
        guard let secondAtom = AtomB.checkIfIsConnected(atom: atomA) else {return}
        
        firstAtom.eletronsNaValencia! -= 1
        secondAtom.eletronsNaValencia! -= 1
        
    }
}
