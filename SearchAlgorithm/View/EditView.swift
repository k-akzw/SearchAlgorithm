//
//  EditView.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 2/2/24.
//

import SwiftUI

struct EditView: View {
  @ObservedObject var searchModel = SearchModel.shared
  @ObservedObject var tree = Tree.shared
  @Binding var edit: Bool

  @State var input: String = ""
  @State var val: Int = -1

  var body: some View {
    VStack {
      HStack {
        Image(systemName: "chevron.left")
        Text("Back")
        Spacer()
      }
      .bold()
      .padding()
      .padding(.bottom, 50)
      .foregroundColor(.blue)
      .onTapGesture {
        edit = false
      }

      TreeView(searchModel: searchModel, tree: tree)

      TextField("Enter key: ", text: $input)
        .keyboardType(.numberPad)
        .frame(width: 280, height: 50)
        .onChange(of: input) { oldValue, newValue in
          self.input = String(newValue.filter { "0123456789".contains($0) })
          if let num = Int(input) {
            val = num
          }
        }

      Text("Insert Node")
        .frame(width: 280, height: 50)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(12)
        .onTapGesture {
          if !input.isEmpty {
            print("Insert button tapped")
            Tree.shared.insertNode(val: Unique(val))
          }
        }

      Spacer()
    }
    .background(Color.secondary.opacity(0.1))
  }
}

#Preview {
  EditView(edit: .constant(true))
}
