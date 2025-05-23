//
//  Card.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 17/05/25.
//

import Foundation
import SwiftUI

struct Card: Identifiable, Hashable {
  var id: String = UUID().uuidString
  var image: String
}

let cards: [Card] = [
  .init(image: "willas"),
  .init(image: "willas-2"),
  .init(image: "willas-3"),
  .init(image: "willas-4"),
  .init(image: "willas-5"),
]
