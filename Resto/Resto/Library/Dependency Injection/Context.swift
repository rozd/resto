//
//  Context.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class Context {
    static let assembler = DefaultAssembler()
}

protocol Assembler: MainAssembler, LocatorAssembler {

}

class DefaultAssembler: Assembler {

}
