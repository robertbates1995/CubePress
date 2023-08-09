//
//  testfile.swift
//  CubePress
//
//  Created by Robert Bates on 8/3/23.
//

import Foundation
import KociembaSolver
import UIKit

protocol CubeMovable: AnyObject {
    func input(moves: [String]) async throws
    func input(move: String) async throws
}
