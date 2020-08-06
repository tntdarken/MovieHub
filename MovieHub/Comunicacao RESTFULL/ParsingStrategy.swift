import Foundation

protocol ParsingStrategy {
    func decode<T:Codable>(data:Data, closure: @escaping (_ sucesso: T?, _ erro:String?) -> Void)
}
