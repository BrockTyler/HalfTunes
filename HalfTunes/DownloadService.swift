//
//  DownloadService.swift
//  HalfTunes
//
//  Created by brock tyler on 2/7/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {

  // SearchViewController creates downloadsSession
  var downloadsSession: URLSession!

  // This dict maintains mapping between a URL and its active Download, if any.
  var activeDownloads: [URL: Download] = [:]
  
  // MARK: - Download methods called by TrackCell delegate methods

  func startDownload(_ track: Track) {
    // 1. Initialize a Download with the track:
    let download = Download(track: track)
    
    // 2. Using the new session object, create a URLSessionDownloadTask with track's preview URL, and set it to task property of the Download:
    download.task = downloadsSession.downloadTask(with: track.previewURL)
    
    // 3. Start the download task by calling resume() on it:
    download.task?.resume()
    
    // 4. Indicate that download is in progress:
    download.isDownloading = true
    
    // 5. Map download URL to its Download in the activeDownloads dict:
    activeDownloads[download.track.previewURL] = download
  }
  // TODO: previewURL is http://a902.phobos.apple.com/...
  // why doesn't ATS prevent this download?

  func pauseDownload(_ track: Track) {
    // TODO
  }

  func cancelDownload(_ track: Track) {
    // TODO
  }

  func resumeDownload(_ track: Track) {
    // TODO
  }

}
