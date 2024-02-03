//
//  ContentView.swift
//  SearchAlgorithm
//
//  Created by Kento Akazawa on 1/29/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @ObservedObject var searchModel = SearchModel.shared
  @State var searchAlgorithm: SearchAlgorithms = .binarySearch
  @State var key: Int = -1
  @State var edit = false
  
  var body: some View {
    VStack {
      if edit {
        EditView(searchModel: searchModel, edit: $edit)
      } else {
        SearchView(searchModel: searchModel,
                   searchAlgorithm: $searchAlgorithm,
                   key: $key,
                   edit: $edit)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.secondary.opacity(0.1))
  }
}

// MARK: - SearchView
struct SearchView: View {
  @ObservedObject var searchModel: SearchModel
  @Binding var searchAlgorithm: SearchAlgorithms
  @Binding var key: Int
  @Binding var edit: Bool

  @State var input: String = ""

  var body: some View {
    HStack {
      Spacer()
      Text("Edit")
        .bold()
        .foregroundStyle(.blue)
        .onTapGesture {
          searchModel.cur = TreeNode(val: Unique(-1))
          edit = true
        }
    }
    .padding(.horizontal)
    .padding(.horizontal)

    SearchPicker(searchAlgorithm: $searchAlgorithm, 
                 input: $input,
                 key: $key)

    ResultView(searchModel: searchModel)

    TreeView(searchModel: searchModel, tree: Tree.shared, edit: $edit)

    Spacer()

    Button(action: {
      if input != "" {
        searchModel.startSearch(key: Unique(key),
                                using: searchAlgorithm,
                                from: Tree.shared.root)
      }
    }, label: {
      Text("Start Searching")
        .bold()
        .frame(width: 280, height: 50)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(12)
        .opacity(input == "" ? 0.4 : 1)
    })

    Spacer(minLength: 20)
  }
}


// MARK: - SearchPicker
struct SearchPicker: View {
  @Binding var searchAlgorithm: SearchAlgorithms
  @Binding var input: String
  @Binding var key: Int

  @State private var isShowingPopover = false

  var body: some View {
    List {
      Picker("Search Algorithm", selection: $searchAlgorithm) {
        ForEach(SearchAlgorithms.allCases, id: \.self) { val in
          Text(val.rawValue)
        }
      }

      TextField("Enter key: ", text: $input)
        .keyboardType(.numberPad)
        .onChange(of: input) { oldValue, newValue in
          // only accept numbers as key
          self.input = String(newValue.filter { "0123456789".contains($0) })
          if let newKey = Int(input) {
            key = newKey
          }
        }
    }
    .frame(height: 150)
    .padding(0)
  }
}

// MARK: - ResultView
struct ResultView: View {
  @ObservedObject var searchModel: SearchModel

  var body: some View {
    HStack {
      Spacer()
      if searchModel.found {
        Text("Key found")
      } else {
        Text("Key not found")
      }
    }
    // display the result if search is done
    .opacity(searchModel.done ? 1 : 0)
    .padding(.horizontal)
  }
}

#Preview {
  ContentView()
}
