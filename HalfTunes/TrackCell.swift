//
//    TrackCell.swift
//    HalfTunes
//
//    Created by brock tyler on 2/7/18.
//    Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
  func pauseTapped(_ cell: TrackCell)
  func resumeTapped(_ cell: TrackCell)
  func cancelTapped(_ cell: TrackCell)
  func downloadTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
  
  // Delegate identifies track for this cell,
  // then passes this to a download service method.
  var delegate: TrackCellDelegate?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var artistLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var downloadButton: UIButton!
  
  @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
    if(pauseButton.titleLabel?.text == "Pause") {
      delegate?.pauseTapped(self)
    } else {
      delegate?.resumeTapped(self)
    }
  }
  
  @IBAction func cancelTapped(_ sender: AnyObject) {
    delegate?.cancelTapped(self)
  }
  
  @IBAction func downloadTapped(_ sender: AnyObject) {
    delegate?.downloadTapped(self)
  }
  
  func configure(track: Track, downloaded: Bool, download: Download?) {
    titleLabel.text = track.name
    artistLabel.text = track.artist
    
    // Show/hide download controls Pause/Resume, Cancel buttons, progress info
    var showDownloadControls = false
    
    // Non-nil Download object means a download is in progress
    if let download = download {
      showDownloadControls = true
      let title = download.isDownloading ? "Pause" : "Resume"
      pauseButton.setTitle(title, for: .normal)
    }
    
    pauseButton.isHidden = !showDownloadControls
    cancelButton.isHidden = !showDownloadControls
    
    // If the track is already downloaded, enable cell selection and hide the Download button
    selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
    
    // If track is downloading, hide the 'Download' button:
    downloadButton.isHidden = downloaded || showDownloadControls
  }
  
}
