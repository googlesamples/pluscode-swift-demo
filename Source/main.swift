// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import OpenLocationCode
import Swifter
import Dispatch
import SwiftyJSON
import Glibc

// Disable stdout buffer (https://stackoverflow.com/a/28180452/72176)
setbuf(stdout, nil);

let server = HttpServer()

// Root path, show help text
server["/"] = { request in
  print("\nHandling request: \(request.params as AnyObject)")
  return HttpResponse.ok(.text("Specify a latitude and longitude to convert."))
}

// Convert latitude and longitude
server["/:latlng"] = { request in

  print("\nHandling request: \(request.params as AnyObject)")

  // URL param
  var latlng = request.params[":latlng"] ?? ""
  if latlng == "" {
    latlng = "37.444796, -122.161538"
  }
  latlng = latlng.filter { "+-,.0123456789".contains($0) }

  // Extract Latitude & Longitude
  let params = latlng.split{$0 == ","}
  if params.count != 2 {
    return HttpResponse.notFound
  }

  let lat = Double(params[0])!
  let lng = params.count > 1 ? Double(params[1])! : 0
  print(String(format:"Converting: %f %f", lat, lng))

  // Response dictionary
  var dict = ["docs": "https://plus.codes"] as [String: Any?]
  dict["latitude"] = lat
  dict["longitude"] = lng


  // Encode as a Plus Code
  if let code = OpenLocationCode.encode(latitude: lat,
                                        longitude: lng,
                                        codeLength: 10) {
    print("Open Location Code: \(code)")
    dict["status"] = "OK!!"
    dict["pluscode"] = code
  } else {
    dict["status"] = "error"
  }

  var json = JSON(dict).rawString() ?? "error"
  json = json.replacingOccurrences(of: "\\/", with: "/")

  return HttpResponse.ok(.text(json))
}

// Start the server & wait for connections
let semaphore = DispatchSemaphore(value: 0)
do {
  try server.start(80, forceIPv4: true)
  print("Server has started on port \(try server.port())...")
  semaphore.wait()
} catch {
  print("Server start error: \(error)")
  semaphore.signal()
}