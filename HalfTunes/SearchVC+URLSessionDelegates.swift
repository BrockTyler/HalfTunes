//
//    SearchVC+URLSessionDelegates.swift
//    HalfTunes
//
//    Created by brock tyler on 2/7/18.
//    Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

// CREATE CUSTOM DELEGATE INSTEAD OF DOWNLOAD TASK W/ COMPLETION HANDLER SO DOWNLOAD PROGRESS CAN BE MONITORED AND UPDATED.
extension SearchViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
    // SAVING AND PLAYING THE TRACK
    // 1. Extract original request URL from the task, look up corresponding Download in active downloads, then remove it from that dict:
    guard let sourceURL = downloadTask.originalRequest?.url else { return }
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    
    // 2. Pass URL to localFilePath(for:) helper method in SearchViewController.swift to create permanent local file path to save to; this is done by appending the lastPathComponent of the URL to the path of the app's Document directory.
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    
    // 3. Move downloaded file, using FileManager, from temp file location to destination file path. First, clear any item at that location before copying the downloaded file. Set download track's downloaded property to true.
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
    } catch {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    
    // 4. Reload corresponding cell using download track's index:
    if let index = download?.track.index {
      DispatchQueue.main.async {
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
      }
    }
  }
}
