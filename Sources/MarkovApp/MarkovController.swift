/*
* Copyright IBM Corporation 2017
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import CloudEnvironment
import Kitura
import KituraContracts

public class MarkovController {
  public let router = Router()
  private let cloudEnv = CloudEnv()
  private let chain = FrequencyMarkovChain<String>()
  private let location = "config/messages.json"

  public var port: Int {
    return cloudEnv.port
  }

  public init() {
    trainChain();
    setup()
  }

  public func setup() {
    router.get("/quote") {
      request, response, next in
      response.headers.setType("json", charset: "utf-8")
      response.send(self.generateQuote())
      next()
    }
    router.all("/", middleware: StaticFileServer())
  }

  public func trainChain() {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let filePath = "\(currentPath)/\(location)"
    if let data = try! String(contentsOfFile: filePath, encoding: .utf8).data(using: .utf8) {
    let decoder = JSONDecoder()
    let messageList = try! decoder.decode([[String]].self, from: data)
    for tokenizedMessage in messageList {
        chain.trainOnTransitionList(list: tokenizedMessage)
    }
      print("Chain successfully trained")
    } else {
      print("It appears the filename you have provided or not provided ... doesn't work")
      exit(0)
    }
  }

  func generateQuote() -> String{
    let startToken = "SENTENCE_START"
    let endToken = "SENTENCE_END"
    var quote = [startToken]
    while quote.last != endToken {
        let nextString = chain.getNextState(currentState: quote.last!)
        quote.append(nextString!)
    }
    quote.removeLast(); quote.removeFirst();
    return quote.reduce("", {$0 + " " + $1}).trimmingCharacters(in: .whitespaces).captalizeFirstCharacter()
  }
}

extension String {
    func captalizeFirstCharacter() -> String {
        var result = self
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        return result
    }
}
