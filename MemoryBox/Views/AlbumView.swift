//
//  AlbumView.swift
//  MemoryBox
//
//  Created by gunner madsen on 10/29/21.
//

import SwiftUI
import Foundation
import Combine

struct AlbumView: View {
    
    @State var showDialog = false
    @ObservedObject var albums = AlbumList()
    
    let twoColumnGrid = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40))
    ]

    var manager = FileSystemManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    Text("My Albums")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .padding()
                    
                    LazyVGrid(columns: twoColumnGrid, alignment: .center) {
                        ForEach(albums.albumList, id: \.self) {
                            album in
                            NavigationLink(destination: ItemsView(albumName: album)) {
                                Text(album)
                                    .frame(width: 175, height: 175)
                                    .border(Color.black)
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(25)
                            }
                        }
                        Button(action: {
                            withAnimation {
                                self.showDialog.toggle()
                            }
                        }) {
                            VStack {
                                Image(systemName: "plus")
                                Text("Add Album")
                            }
                        }
                        .padding()
                        .frame(width: 175, height: 175)
                        .border(Color.black)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(25)
                    }
                }
            }
            .navigationBarItems(
                leading: Button(
                    action: {
                        // for development purposes, deleting all albums
                        self.albums.albumList.removeAll()
                        try? self.manager.deleteAllPhotoAlbums()
                    },
                    label: {
                        Image(systemName: "trash")
                    }
                ),
                trailing: Button(
                    action: {
                        print("trailing button")
                    },
                    label: {
                        Button(action: {
                            withAnimation {
                                self.showDialog.toggle()
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                )
            )
        }
        
        .alert(isPresented: $showDialog, TextAlert(title: "New Album", message: "Enter a name for this album") { result in
            
            if let text = result {
                self.albums.albumList.insert(text, at: 0)
            }
            else {
                print("dialog was cancelled")
            }
        })
        .background(Color.orange)
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}

class AlbumList: ObservableObject {
    @Published var albumList: Array<String> {
        didSet {
            UserDefaults.standard.set(albumList, forKey: "AlbumList")
        }
    }
    
    init() {
        self.albumList = UserDefaults.standard.object(forKey: "AlbumList") as? Array<String> ?? Array<String>()
    }
}
