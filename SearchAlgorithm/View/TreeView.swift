//
//  TreeView.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 2/2/24.
//

import SwiftUI

struct TreeView: View {
  @ObservedObject var searchModel: SearchModel
  @ObservedObject var tree: Tree
  @Binding var edit: Bool

  var body: some View {
    ScrollView {
      ScrollView(.horizontal) {
        DiagramModel(treeNode: tree.root, node: { value in
          Text("\(value.val)")
        }, searchModel: searchModel, tree: tree, edit: $edit)
      }
    }
  }
}

#Preview {
  TreeView(searchModel: SearchModel.shared, tree: Tree.shared, edit: .constant(false))
}
