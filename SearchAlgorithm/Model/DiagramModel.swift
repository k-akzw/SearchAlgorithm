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

  typealias Key = CollectDict<A.ID, Anchor<CGPoint>>

  var body: some View {
    VStack(alignment: .center) {
      node(treeNode.val)
        .modifier(RoundedCircleStyle(visiting: treeNode.val as! Unique<Int> == searchModel.cur.val))
        .anchorPreference(key: Key.self, value: .center, transform: {
          [self.treeNode.val.id: $0]
        })
      HStack(alignment: .top, spacing: 10, content: {
        ForEach(treeNode.children, id: \.val.id) { child in
          DiagramModel(treeNode: child, node: self.node, searchModel: searchModel, tree: tree)
        }
      })
    }.backgroundPreferenceValue(Key.self, { (centers: [A.ID: Anchor<CGPoint>]) in
      // draws a line from mid point of parent node to mid point of child node
      GeometryReader { proxy in
        ForEach(self.treeNode.children, id: \.val.id) { child in
          Path { path in
            path.move(to: proxy[centers[self.treeNode.val.id]!])
            path.addLine(to: proxy[centers[child.val.id]!])
          }.stroke()
        }
      }
    })
  }
}
