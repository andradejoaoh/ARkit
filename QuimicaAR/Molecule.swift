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
    
    func removeAtom(atom: Atomo) {
        
        atoms.removeAll{ $0 == atom }
        atom.atomsConnected.removeAll()

    }
    
    func addConnection(atomA: Atomo, AtomB: Atomo) {
        guard let firstAtom = atomA.checkIfIsConnected(atom: AtomB) else {return}
        guard let secondAtom = AtomB.checkIfIsConnected(atom: atomA) else {return}
        
        firstAtom.atomsConnected.append(secondAtom)
        secondAtom.atomsConnected.append(firstAtom)
        
        firstAtom.eletronsNaValencia! -= 1
        secondAtom.eletronsNaValencia! -= 1
        
    }
    
    func checkIfCanConnected(atomA: Atomo, atomB: Atomo) -> Bool {
        
        var check: Bool = true
        
        if atomA.eletronsNaValencia! > 0, atomB.eletronsNaValencia! > 0 {
            
            for atom in atomA.atomsConnected {
                
                if atomB.id == atom.id {
                    check = false
                }
                
            }
            
        } else {
            check = false
        }

        return check
    }
    
}
