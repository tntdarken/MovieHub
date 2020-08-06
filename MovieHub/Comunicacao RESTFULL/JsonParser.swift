//
//  JsonParser.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import Foundation

class JsonParser : ParsingStrategy {
    var Data: Data?
    
    init(){
    }
    
    func decode<T:Codable>(data:Data, closure: @escaping (_ sucesso: T?, _ erro:String?) -> Void){
        do {
            let decoder = JSONDecoder()
            let todo = try decoder.decode(T.self, from: data)
            closure(todo, nil)
        } catch {
            closure(nil, "error trying to convert data to JSON")
        }
        
    }
}
