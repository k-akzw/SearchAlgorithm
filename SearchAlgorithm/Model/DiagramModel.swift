//
//  DiagramModel.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI

struct DiagramModel<A: Identifiable & Comparable, V: View>: View {
  let treeNode: TreeNode<A>
  let node: (A) -> V
  @ObservedObject var searchModel: SearchModel
  @ObservedObject var tree: Tree
  @Binding var edit: Bool

  typealias Key = CollectDict<A.ID, Anchor<CGPoint>>

  var body: some View {
    VStack(alignment: .center) {
      node(treeNode.val)
        .modifier(RoundedCircleStyle(visiting: treeNode.id == searchModel.cur.id,
                                     delete: treeNode.id == tree.nodeToDelete?.id))
        .anchorPreference(key: Key.self, value: .center, transform: {
          [self.treeNode.val.id: $0]
        })
        .onTapGesture {
          if edit {
            tree.nodeToDelete = (treeNode as! TreeNode<Unique<Int>>)
          }
        }
      HStack(alignment: .top, spacing: 10, content: {
        ForEach(treeNode.getChildren(), id: \.val.id) { child in
          DiagramModel(treeNode: child, node: self.node, searchModel: searchModel, tree: tree, edit: $edit)
        }
      })
    }.backgroundPreferenceValue(Key.self, { (centers: [A.ID: Anchor<CGPoint>]) in
      // draws a line from mid point of parent node to mid point of child node
      GeometryReader { proxy in
        ForEach(self.treeNode.getChildren(), id: \.val.id) { child in
          Path { path in
            path.move(to: proxy[centers[self.treeNode.val.id]!])
            path.addLine(to: proxy[centers[child.val.id]!])
          }.stroke()
        }
      }
    })
  }
}
