//
//  PhotoModel.swift
//  MemoryBox
//
//  Created by gunner madsen on 11/4/21.
//

import Foundation
import Photos
import SwiftUI

struct PhotoModel: Identifiable, Hashable {
    enum MediaType {
        case photo, video, livePhoto
    }
    
    var id: String
    var photo: UIImage?
    var url: URL?
    var livePhoto: PHLivePhoto?
    var mediaType: MediaType = .photo
    
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }
    
    init(with videoURL: URL) {
        id = UUID().uuidString
        url = videoURL
        mediaType = .video
    }
    
    init(with livePhoto: PHLivePhoto) {
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
    
    mutating func delete() {
        switch mediaType {
            case .photo: photo = nil
            case .livePhoto: livePhoto = nil
            case .video:
                guard let url = url else { return }
                try? FileManager.default.removeItem(at: url)
                self.url = nil
        }
    }
}
