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
        
        factButton.layer.cornerRadius = 5.0
        factButton.clipsToBounds = true
        
        catImageView.layer.cornerRadius = 5.0
        catImageView.clipsToBounds = true
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
        
        //The current parsed tag is presented as `elementName` in this function
        if elementName == "element" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //The value of current parsed tag is presented as `string` in this function
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[currentElement] == nil {
                   xmlDict.updateValue(string, forKey: currentElement)
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //The closing tag is presented as `elementName` in this function
        if elementName == "element" {
            xmlDictArr.append(xmlDict)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        //Called when the parsing is complete
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
