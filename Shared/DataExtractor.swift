//
//  DataExtractor.swift
//  GREWordPlay
//
//  Created by Sahil Sarna on 3/4/23.
//

import Foundation

struct FlashWord: Identifiable {
    var word: String = ""
    var definition: String = ""
    var partOfSpeech: String = ""
    var example: String = ""
    let id = UUID()
    
    init(raw: [String]){
        word = raw[0]
        definition = raw[1]
        partOfSpeech = raw[2]
        example = raw[3]
    }
}

func readCSV(from fileName: String) -> [FlashWord]{
    var csvToWords = [FlashWord]()
    
    // File Path
    guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv")
    else{
        return []
    }
    
    var data = ""
    do{
        data = try String(contentsOfFile: filePath)
    }catch{
        print(error)
        return []
    }
    
    var rows = data.components(separatedBy: "\n")
    
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows{
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount{
            let wordStruct = FlashWord.init(raw: csvColumns)
            csvToWords.append(wordStruct)
        }
    }
    
    
    return csvToWords
}
