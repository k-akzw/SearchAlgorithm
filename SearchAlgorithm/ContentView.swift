//
//  TreeModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

struct ContentView: View {

  @State var tree = Tree.shared.tree

  var body: some View {
    DiagramModel(treeNode: tree) { value in
      Text("\(value.val)")
        .modifier(RoundedCircleStyle())
    }
  }
}

#Preview {
  ContentView()
}
