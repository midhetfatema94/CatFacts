//
//  ViewController.swift
//  CatFacts
//
//  Created by Midhet Sulemani on 4/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catFact: UILabel!
    @IBOutlet weak var factButton: UIButton!
    
    var facts = [Fact]()
    var xmlDict = [String: Any]()
    var xmlDictArr = [[String: Any]]()
    var currentElement = ""
    var pictureCount = 1
    
    @IBAction func nextFactTapped(_ sender: UIButton) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCatFacts()
    }
    
    func loadCatFacts() {
        let xmlResponseData = Bundle.main.getFileData("catfacts.xml")
        let parser = XMLParser(data: xmlResponseData)
        parser.delegate = self
        parser.parse()
    }
}

extension ViewController: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        print("element name", elementName, "attribute dictionary", attributeDict)
        
        if elementName == "element" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("found characters", string)
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[currentElement] == nil {
                   xmlDict.updateValue(string, forKey: currentElement)
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "element" {
            xmlDictArr.append(xmlDict)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("document ended")
        parsingCompleted()
    }
    
    func parsingCompleted() {
        self.facts = self.xmlDictArr.map { Fact(details: $0) }
        self.updateUI()
    }
    
    func updateUI() {
        catImageView.image = UIImage(named: "cat\(pictureCount)")
        pictureCount += 1
        if pictureCount > 6 {
            pictureCount = 1
        }
        
        catFact.text = facts[factButton.tag].fact
        factButton.tag += 1
        if factButton.tag >= facts.count {
            factButton.tag = 0
        }
    }
}

extension Bundle {
    func getFileData(_ file: String) -> Data {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle")
        }
        
        return data
    }
}
