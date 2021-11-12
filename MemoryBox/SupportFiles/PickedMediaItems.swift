//
//  PhotoPickerModel.swift
//  MemoryBox
//
//  Created by Gunner Madsen.
//

import SwiftUI
import Photos


class PickedMediaItems: ObservableObject {
    @Published var items = [PhotoModel]()

    func append(item: PhotoModel) {
        items.append(item)
    }

    func saveAll(photos: Array<PhotoModel>) {
        for photo in photos {
            append(item: photo)
        }
    }

    func deleteAll() {
        for (index, _) in items.enumerated() {
            items[index].delete()
        }
        
        items.removeAll()
    }
}
