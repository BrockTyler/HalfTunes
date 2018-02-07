//
//    QueryService.swift
//    HalfTunes
//
//    Created by brock tyler on 2/7/18.
//    Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array of Tracks
class QueryService {
  
  typealias JSONDictionary = [String: Any]
  typealias QueryResult = ([Track]?, String) -> ()
  
  var tracks: [Track] = []
  var errorMessage = ""
  
  // CREATE DATA TASK TO QUERY iTUNES SEARCH API FOR USER'S SEARCH TERM
  // (1a) Create URLSession and init with default config.
  let defaultSession = URLSession(configuration: .default)
  
  /*
   Declare URLSessionDataTask variable, which will be used to make an HTTP GET
   request ot the iTunes Search web service when user performs search.
   
   This data task will be re-initialized whenever user enters a new search string.
   */
  var dataTask: URLSessionDataTask?
  
  func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
    
    // (1b) For new user query, cancel the data task if it already exists.
    // Why? B/c you want to reuse the data task object for this new query.
    dataTask?.cancel()
    
    // (2) Add URLComponents object to include user's search string in the query URL, then set its query string:
    if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
      
      urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
      
      // (3) urlComponent's url property might be nil, so optional-bind it:
      guard let url = urlComponents.url else { return }
      
      // (4) Initialize a URLSessionDataTask with query url and completion handler to call when the data task completes.
      dataTask = defaultSession.dataTask(with: url) { data, response, error in
        defer { self.dataTask = nil }
        
        // (5) If http request is successful, call updateSearchResults to parse the response data into the tracks array:
        if let error = error {
          self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
          self.updateSearchResults(data)
          
          // (6) Switch to the main queue to pass tracks to completion handler in SearchVC+SearchBarDelegate.swift:
          DispatchQueue.main.async {
            completion(self.tracks, self.errorMessage)
          }
        }
      }
      // (7) Call .resume() on dataTask to start the data task; all tasks start in suspended state by default, so the task must be started.
      dataTask?.resume()
    }
  }
  
  fileprivate func updateSearchResults(_ data: Data) {
    var response: JSONDictionary?
    tracks.removeAll()
    
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }
    
    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
    }
    var index = 0
    for trackDictionary in array {
      if let trackDictionary = trackDictionary as? JSONDictionary,
        let previewURLString = trackDictionary["previewUrl"] as? String,
        let previewURL = URL(string: previewURLString),
        let name = trackDictionary["trackName"] as? String,
        let artist = trackDictionary["artistName"] as? String {
        tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
        index += 1
      } else {
        errorMessage += "Problem parsing trackDictionary\n"
      }
    }
  }
  
}
