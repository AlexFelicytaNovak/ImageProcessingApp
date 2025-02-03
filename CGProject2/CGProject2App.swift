//
//  CGProject2App.swift
//  CGProject2
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI

@main
struct CGProject2App: App {
    
    
    var body: some Scene {
        DocumentGroup(newDocument: Document()) { file in
            ContentView(doc: file.$document)
        }
        
        .commands{
            CommandGroup(after: .saveItem) {
                Button("Save Copy…") {
                    (NSApplication.shared.keyWindow?.windowController?.document as? NSDocument)?.saveAs(nil)
                }
               
            }
        }
    }
}

