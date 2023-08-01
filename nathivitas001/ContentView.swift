//
//  ContentView.swift
//  nathivitas001
//
//  Created by Naty Caraballo on 1/8/23.
//

import SwiftUI

//struct ContentView: View {
//    @Binding var document: nathivitas001Document
//
//    var body: some View {
//        TextEditor(text: $document.text)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(document: .constant(nathivitas001Document()))
//    }
//}

struct ContentView: View {
    @State private var documents = [URL]()

    var body: some View {
        NavigationView {
            List(documents, id: \.self) { url in
                NavigationLink(destination: DocumentView(url: url)) {
                    Text(url.lastPathComponent)
                }
            }
            .navigationTitle("Documents")
            .navigationBarItems(trailing: Button("New Document") {
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(UUID().uuidString)
                let _ = FileManager.default.createFile(atPath: url.path, contents: Data(), attributes: nil)
                documents.append(url)
            })
            .onAppear {
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let urls = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
                documents = urls ?? []
            }
        }
    }
}
struct DocumentView: View {
    let url: URL
    @State private var text = ""

    var body: some View {
        TextEditor(text: $text)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Save") {
                try? text.write(to: url, atomically: true, encoding: .utf8)
            })
            .onAppear {
                text = try! String(contentsOf: url)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
