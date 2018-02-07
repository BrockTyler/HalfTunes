//
//    Download.swift
//    HalfTunes
//
//    Created by brock tyler on 2/7/18.
//    Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation


// CREATE DOWNLOAD CLASS OBJECTS TO MAKE IT EASIER TO HANDLE MULTIPLE DOWNLOADS
class Download {
  
  var track: Track
  init(track: Track) {
    self.track = track
  }
  
  // Download service sets these values:
  var task: URLSessionDownloadTask?
  var isDownloading = false          // whether download ongoing or paused
  var resumeData: Data?                // stores data produced when user pauses download
  
  // Download delegate sets this value:
  var progress: Float = 0            // fractional progross of download (btwn 0.0 and 1.0)
  
}
