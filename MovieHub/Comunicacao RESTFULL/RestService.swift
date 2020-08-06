import Foundation

class RestService {
    var parser: ParsingStrategy
    let http = URLSession.shared
    var request: URLRequest?
    
    // this is a http façade to simplify the use and enable the reuse of http rest communication
    init(parser:ParsingStrategy){
        self.parser = parser
    }
    
    func get<T:Codable>(url:String, param: Data?, closure: @escaping (_ sucesso:T?, _ error:ErroRest?) -> Void){
        self.prepare(method: "GET", url: url, param:param)
        self.fetch(callback: closure)
    }
    
    func post<T:Codable>(url:String, param: Data?, closure: @escaping (_ sucesso:T?, _ error:ErroRest?) -> Void){
        self.prepare(method: "POST", url: url, param: param)
        self.fetch(callback: closure)
    }
    
    private func prepare(method:String, url:String, param: Data?) -> Void{
        let url = URL(string: url)!
        self.request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 15)
        request!.httpMethod = method
        if let param = param {
            request!.httpBody = param
        }
        request!.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request!.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    // fetch the data using URLSession dataTask. Runs the closure on completion
    private func fetch<T:Codable>(callback: @escaping(_ sucesso: T?, _ error:ErroRest?) -> Void){
        let task = http.dataTask(with: request!, completionHandler: {(data,response,error) -> Void in
            if error != nil {
                callback(nil, ErroRest(tipo: 1, titulo: "Erro", mensagem: error?.localizedDescription))
            }
            if data != nil {
                if let data = data {
                    if let res = response as? HTTPURLResponse  {
                        if res.statusCode == 200 {
                            self.parser.decode(data: data, closure: {(sucesso:T?, error:String?) in
                                DispatchQueue.main.async {
                                    if let suc = sucesso {
                                        callback(suc,nil)
                                    } else if error != nil{
                                        callback(nil, ErroRest(tipo: 0, titulo: "Erro", mensagem: "Os dados recebidos estão corrompidos. Entre em contato com o atendimento"))
                                    }
                                }
                            })
                        } else if res.statusCode == 404{
                            callback(nil,ErroRest(tipo: 0, titulo: "Erro", mensagem: "Url não encontrada"))
                        } else if res.statusCode == 418 || res.statusCode == 503 {
                            self.parser.decode(data: data, closure: {(sucesso:ErroRest?, error:String?) in
                                DispatchQueue.main.async {
                                    if let suc = sucesso {
                                        callback(nil, suc)
                                    } else if let er = error{
                                        callback(nil, ErroRest(tipo: 1, titulo: "Erro", mensagem: er))
                                    }
                                }
                            })
                        } else {
                            self.parser.decode(data: data, closure: {(sucesso:ErroRest?, error:String?) in
                                DispatchQueue.main.async {
                                    if let suc = sucesso {
                                        callback(nil, suc)
                                    } else if let er = error{
                                        callback(nil, ErroRest(tipo: 0, titulo: "Erro", mensagem: er))
                                    }
                                }
                            })
                        }
                    }
                }
            }

        })
        task.resume()
    }
}
