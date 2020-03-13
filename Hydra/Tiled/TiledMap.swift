//
//  TiledMap.swift
//  RPG-SpriteKit
//
//  Created by Pablo Henrique Bertaco on 21/02/20.
//  Copyright © 2020 OrganizationName. All rights reserved.
//

import SpriteKit

class TiledMap: SKNode, XMLParserDelegate {
    
    internal enum CompressionType: String {
        case uncompressed
        case zlib
        case gzip
    }
    
    weak var delegate: TiledMapDelegate?
    
    var version = ""
    var tiledVersion = ""
    var orientation = ""
    var renderOrder = ""
    var compressionLevel = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    var tileWidth: CGFloat = 0
    var tileHeight: CGFloat = 0
    var infinite = false
    var nextLayerId = 0
    var nextObjectId = 0
    
    var size: CGSize {
        get {
            return CGSize(width: self.width * self.tileWidth,
                          height: self.height * self.tileHeight)
        }
    }
    
    var tilesetList = [TiledTileset]()
    var layerList = [TiledLayer]()
    var objectGroupList = [TiledObjectGroup]()
    var tiledData = TiledData()
    
    static weak var current: TiledMap?
    
    init(fileNamed filename: String, x: CGFloat, y: CGFloat, delegate: TiledMapDelegate? = nil) {
        super.init()
        guard let url = self.url(forResource: filename) else {
            return
        }
        guard let parser = XMLParser(contentsOf: url) else {
            return
        }
        TiledMap.current = self
        self.delegate = delegate
        parser.delegate = self
        parser.parse()
        self.position = CGPoint(x: self.size.width * x - self.size.width / 2 + self.tileWidth / 2, y: self.size.height * y + self.size.height / 2 - self.tileWidth / 2)
    }
    
    convenience init(fileNamed filename: String, position: CGPoint?, delegate: TiledMapDelegate? = nil) {
        let position = position ?? .zero
        if position == .zero {
            
        }
        self.init(fileNamed: filename, x: position.x, y:position.y, delegate:delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func url(forResource name: String?) -> URL? {
        let url = Bundle.main.url(forResource: name, withExtension: "tmx")
//        if url == nil {
//             return Bundle.main.url(forResource: "default", withExtension: "tmx")
//        }
        return url
    }
    
    func bool(key:String, from attributeDict: [String : String]) -> Bool {
        return attributeDict[key] ?? "0" == "1"
    }
    
    func int(key:String, from attributeDict: [String : String]) -> Int {
        return Int(attributeDict[key] ?? "") ?? -1
    }
    
    func float(key:String, from attributeDict: [String : String]) -> CGFloat {
        return CGFloat(Int(attributeDict[key] ?? "") ?? -1)
    }
    
    func string(key:String, from attributeDict: [String : String]) -> String {
        return attributeDict[key] ?? ""
    }
    
    func configure(attributeDict: [String : String]) {
        self.version =  self.string(key: "version", from: attributeDict)
        self.tiledVersion = self.string(key: "tiledversion", from: attributeDict)
        self.orientation = self.string(key: "orientation", from: attributeDict)
        self.renderOrder = self.string(key: "renderorder", from: attributeDict)
        self.compressionLevel = self.string(key: "compressionlevel", from: attributeDict)
        self.width = self.float(key: "width", from: attributeDict)
        self.height = self.float(key: "height", from: attributeDict)
        self.tileWidth = self.float(key: "tilewidth", from: attributeDict)
        self.tileHeight = self.float(key: "tileheight", from: attributeDict)
        self.infinite = self.bool(key: "infinite", from: attributeDict)
        self.nextLayerId = self.int(key: "nextlayerid", from: attributeDict)
        self.nextObjectId = self.int(key: "nextobjectid", from: attributeDict)
    }
    
    func loadTiledTileset(attributeDict: [String : String]) -> TiledTileset {
//        let firstgid = self.int(key: "firstgid", from: attributeDict)
        let name = self.string(key: "name", from: attributeDict)
        let tileWidth = self.float(key: "tilewidth", from: attributeDict)
        let tileHeight = self.float(key: "tileheight", from: attributeDict)
//        let tilecount = self.int(key: "tilecount", from: attributeDict)
//        let columns = self.int(key: "columns", from: attributeDict)
        
        let tileset = TiledTileset(imageNamed: name)
        tileset.load(tileWidth: tileWidth, tileHeight: tileHeight)
        
        return tileset
    }
    
    func loadLayer(attributeDict: [String : String]) -> TiledLayer {
        let layer = TiledLayer()
        layer.id = self.string(key: "id", from: attributeDict)
        layer.name = self.string(key: "name", from: attributeDict)
        layer.width = self.float(key: "width", from: attributeDict)
        layer.height = self.float(key: "height", from: attributeDict)
        return layer
    }
    
    func loadData(attributeDict: [String : String]) -> TiledData {
        let tiledData = TiledData()
        tiledData.encoding = self.string(key: "encoding", from: attributeDict)
        tiledData.compression = self.string(key: "compression", from: attributeDict)
        return tiledData
    }
    
    func loadObjectGroup(attributeDict: [String : String]) -> TiledObjectGroup {
        let objectGroup = TiledObjectGroup()
        objectGroup.id = self.string(key: "id", from: attributeDict)
        objectGroup.name = self.string(key: "name", from: attributeDict)
        return objectGroup
    }
    
    func loadObject(attributeDict: [String : String]) -> TiledObject {
        var attributeDict = attributeDict
        
        let object = TiledObject()
        object.id = self.string(key: "id", from: attributeDict)
        object.name = self.string(key: "name", from: attributeDict)
        object.type = self.string(key: "type", from: attributeDict)
        object.x = self.float(key: "x", from: attributeDict)
        object.y = self.float(key: "y", from: attributeDict)
        object.width = self.float(key: "width", from: attributeDict)
        object.height = self.float(key: "height", from: attributeDict)
        
        attributeDict["id"] = nil
        attributeDict["name"] = nil
        attributeDict["type"] = nil
        attributeDict["x"] = nil
        attributeDict["y"] = nil
        attributeDict["width"] = nil
        attributeDict["height"] = nil
        
        object.attributeDict = attributeDict
        
        return object
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        switch elementName {
        case "map":
            self.configure(attributeDict: attributeDict)
            break
        case "tileset":
            let tileset = self.loadTiledTileset(attributeDict: attributeDict)
            self.tilesetList.append(tileset)
            break
        case "image":
            break
        case "layer":
            let layer = self.loadLayer(attributeDict: attributeDict)
            self.layerList.append(layer)
            break
        case "data":
            let tiledData = self.loadData(attributeDict: attributeDict)
            self.tiledData = tiledData
            break
        case "objectgroup":
            let objectGroup = self.loadObjectGroup(attributeDict: attributeDict)
            self.objectGroupList.append(objectGroup)
            break
        case "object":
            let object = self.loadObject(attributeDict: attributeDict)
            self.objectGroupList.last?.objectList.append(object)
            break
        default:
//            print("didStartElement: \(elementName)")
//            print("attributeDict: \(attributeDict)\n")
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case "map":
            break
        case "tileset":
            break
        case "image":
            break
        case "layer":
            break
        case "data":
            break
        case "objectgroup":
            if let objectGroup = self.objectGroupList.last {
                self.addObjectGroup(objectGroup: objectGroup)
            }
            break
        case "object":
            break
        default:
//            print("didEndElement: \(elementName)")
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let string = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.isEmpty {
            return
        }
        
        var idList = [Int]()
        let encoding = self.tiledData.encoding
        
        switch encoding {
        case "csv":
            idList = self.decode(csvString: string)
            break
        case "base64":
            idList = self.decode(base64String: string, compression: self.tiledData.compression)
            break
        default:
            break
        }
        
        if idList.count > 0 {
            self.loadLayer(idList: idList)
        }
    }
    
    func decode(csvString text: String) -> [Int] {
        return text.scrub().components(separatedBy: ",").map { Int($0) ?? 0 }
    }
    
    func decode(base64String text: String, compression: String = "") -> [Int] {

        guard let decodedData = Data(base64Encoded: text, options: .ignoreUnknownCharacters) else {
            return []
        }

        switch compression {
        case "zlib", "gzip":
            if let decompressed = try? decodedData.gunzipped() {
                return decompressed.toArray(type: UInt32.self).map { Int($0) }
            }
        case "zstd":
            fatalError("zstd has not been implemented")
        default:
            return decodedData.toArray(type: UInt32.self).map { Int($0) }
        }
        
        return []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parser.delegate = nil
    }
    
    func loadLayer(idList: [Int]) {
        guard let map = TiledMap.current else {
            return
        }
        
        var i = idList.makeIterator()
        for y in 0..<Int(map.height) {
            for x in 0..<Int(map.width) {
                let id = Int(i.next() ?? 0)
                guard id != 0 else { continue }
                var tilecount = 0
                for tileset in self.tilesetList {
                    let lastTilecount = tilecount
                    tilecount = tilecount + tileset.tileTextures.count
                    
                    if id > lastTilecount && id <= tilecount {
                        let texture = tileset.tileTextures[id - lastTilecount - 1]
                        self.addTile(id: id, texture: texture, x: x, y: y)
                        break
                    }
                }
            }
        }
    }
    
    func addTile(id: Int, texture: SKTexture, x: Int, y: Int) {
        if let delegate = self.delegate {
            if !delegate.addTile(self, id: id, texture: texture, x: x, y: y) {
                self.addChild(TiledTile(texture: texture, x: x, y: y))
            }
        } else {
            self.addChild(TiledTile(texture: texture, x: x, y: y))
        }
    }
    
    func addObjectGroup(objectGroup: TiledObjectGroup) {
        self.delegate?.addObjectGroup(self, objectGroup: objectGroup)
    }
}

protocol TiledMapDelegate: class {
    func addTile(_ tiledMap: TiledMap, id: Int, texture: SKTexture, x: Int, y: Int) -> Bool // handled ?
    func addObjectGroup(_ tiledMap: TiledMap, objectGroup: TiledObjectGroup)
}

public extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { (unsafeRawBufferPointer) in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: T.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            let pointee = unsafePointer.pointee
            return pointee
        }
    }
    
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes { (unsafeRawBufferPointer) in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: T.self)
            let unsafePointer = unsafeBufferPointer.baseAddress
            return [T](UnsafeBufferPointer(start: unsafePointer, count: self.count / MemoryLayout<T>.stride))
        }
    }
}
