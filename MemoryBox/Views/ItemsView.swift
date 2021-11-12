//
//  ItemsView.swift
//  MemoryBox
//
//  Created by GunnerMadsen.
//

import SwiftUI
import AVKit

struct ItemsView: View {
    
    var albumName: String

    @State private var showSheet = false
    @State private var showImageSheet = false
    @ObservedObject private var mediaItems = PickedMediaItems()
    private var manager = FileSystemManager()

    init(albumName: String) {
        self.albumName = albumName

        loadImagesInModel()
    }
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
    ]

    func loadImagesInModel() {
        let photos = manager.getPhotosFromDirectory(albumName)

        if photos != nil {
            mediaItems.saveAll(photos: photos!)
        }
    }
    
    var body: some View {
//        NavigationView {
            ScrollView {
                LazyVGrid(columns: threeColumnGrid, alignment: .center) {
                    ForEach(mediaItems.items, id: \.id) {
                        item in
                        GeometryReader {
                            gr in
                            if item.mediaType == .photo {
                                Image(uiImage: item.photo ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFill()
                                    .frame(height: gr.size.width)
                                
                            }
                            else if item.mediaType == .video {
                                if let url = item.url {
                                    VideoPlayer(player: AVPlayer(url: url))
                                        .frame(height: 200)
                                }
                                else {
                                    EmptyView()
                                }
                            }
                            else {
                                if let livePhoto = item.livePhoto {
                                    LivePhotoView(livePhoto: livePhoto)
                                        .frame(height: 200)
                                }
                                else {
                                    EmptyView()
                                }
                            }
                        }
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture(count: 1) {
                            print("Media Object tapped")
                            showImageSheet.toggle()
                        }
                        .sheet(isPresented: $showImageSheet) {
                            SelectedImageView()
                        }
                    }
                }
//            }
        }
        .sheet(isPresented: $showSheet, content: {
            PhotoPicker(mediaItems: mediaItems, albumName: albumName) { didSelectItem in
                // Handle didSelectItems value here...
                showSheet = false
            }
        })
        .navigationTitle(self.albumName)
        .navigationBarItems(
//            leading: Button(
//                action: {
//                    mediaItems.deleteAll()
//                },
//                label: {
//                    Image(systemName: "trash")
//                        .foregroundColor(.red)
//                }
//            ),
            trailing: Button(
                action: {
                    showSheet = true
                },
                label: {
//                    Image(systemName: "plus")
                    Text("Edit")
                }
            )
        )
    }
    
    fileprivate func getMediaImageName(using item: PhotoModel) -> String {
        switch item.mediaType {
            case .photo: return "photo"
            case .video: return "video"
            case .livePhoto: return "livephoto"
        }
    }
}


struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(albumName: "Nature Photos")
    }
}

