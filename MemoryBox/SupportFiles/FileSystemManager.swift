//
//  FileSystemManager.swift
//  MemoryBox
//
//  Created by Gunner Madsen.
//
import Foundation
import SwiftUI

class FileSystemManager {

    private let manager = FileManager.default

    public func createLibraryDirectory() throws -> Void {
        let rootFolderURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let nestedFolderURL = rootFolderURL!.appendingPathComponent("PhotoLibrary")

        do {
            try manager.createDirectory(at: nestedFolderURL, withIntermediateDirectories: false, attributes: nil)
        }
        catch CocoaError.fileWriteFileExists {
            print("createLibraryDirectory()", "Folder already exists")
        }
        catch {
            throw error
        }
    }

    public func eraseDirectoryContentsOnStartup() throws -> Void {
        let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentsUrl.appendingPathComponent("PhotoLibrary")

        do {
            let fileURLs = try manager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if fileURL.pathExtension == "png" {
                    try manager.removeItem(at: fileURL)
                }
            }
        }
        catch {
            print("eraseDirectoryContentsOnStartup()", error)
        }
    }

    public func writeImageToFileSystem(_ image: UIImage, _ id: String, albumName: String) -> Void  {

        if let pngData = image.pngData(), let path = documentDirectoryPath()?.appendingPathComponent("PhotoLibrary/\(albumName)/\(id).png") {
            do {
                guard let photoLibraryPath = documentDirectoryPath()?.appendingPathComponent("PhotoLibrary/\(albumName)") else {
                    return
                }
                let urls = try manager.contentsOfDirectory(at: photoLibraryPath, includingPropertiesForKeys: nil)
                print(urls)

                try pngData.write(to: path)
            }
            catch {
                print(error)
                print("An error occurred while writing to the file system")
            }
        }
    }

    public func deletePhotoAlbum(albumName: String) throws -> Void {
        do {
            let rootFolderURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let nestedFolderURL = rootFolderURL!.appendingPathComponent("PhotoLibrary/\(albumName)")

            try? manager.removeItem(at: nestedFolderURL)
        }
        catch {
            print(error)
        }
    }

    public func deleteAllPhotoAlbums() throws -> Void {
        do {
            guard let urls = manager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PhotoLibrary") else {
                return
            }

            let fileUrls = try manager.contentsOfDirectory(at: urls, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

            printPhotoAlbumFolderList()

            for url in fileUrls {
                try? manager.removeItem(at: url)
            }
        }
        catch {
            print(error)
        }
    }

    public func createAlbumFolder(albumName: String) throws -> Void {
        do {
            let rootFolderURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let nestedFolderURL = rootFolderURL!.appendingPathComponent("PhotoLibrary/\(albumName)")

            try manager.createDirectory(at: nestedFolderURL, withIntermediateDirectories: false, attributes: nil)
        }
        catch CocoaError.fileWriteFileExists {
            print("createAlbumFolder()", "Folder already exists")
        }
        catch {
            throw error
        }
    }

    func documentDirectoryPath() -> URL? {
        let path = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }

    func printListOfImagesInFolder() {
        let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try manager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }

    func printPhotoAlbumFolderList() {
        let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let rootFolderURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let nestedFolderURL = rootFolderURL!.appendingPathComponent("PhotoLibrary")
            print(nestedFolderURL)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }

    public func getPhotosFromDirectory(_ albumName: String?) -> [PhotoModel]? {
        var documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        if albumName != nil {
            documentsURL = documentsURL.appendingPathComponent("PhotoLibrary/\(albumName ?? "")")
        }

        do {
            let fileURLs = try manager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs)

            var photos = [PhotoModel]()

            for url in fileURLs {
                let file = try Data(contentsOf: url)
                let photo = UIImage(data: file)
                let photoModel = PhotoModel(with: photo!)
                photos.append(photoModel)
            }

            return photos
        }
        catch {
            print("An error occurred while retrieving the file urls \(documentsURL.path): \(error.localizedDescription)")
            return nil
        }
    }
}
