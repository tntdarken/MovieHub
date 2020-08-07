//
//  DownloadImageView.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import Foundation
import UIKit

class DownloadImageView : UIImageView{
    var progress : UIActivityIndicatorView?
    let queue = OperationQueue()
    let mainQueue = OperationQueue.main
    var imgUrl: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        createProgress()
    }
    
    override init(frame: CGRect){
        super.init(frame:frame)
        createProgress()
    }
    
    // creates the loading
    func createProgress() {
        progress = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        addSubview(progress!)
    }
    
    override func layoutSubviews() {
        progress!.center = convert(self.center, from: self.superview)
    }
    
    // this method starts the download and sets the image if the url is valid
    func setUrl(_ url: String){
        imgUrl = url
        setUrl(url, cache: true)
    }
    
    // this method also astarts the download and sets the image if the url is valid
    func setUrl(_ url:String, cache : Bool){
        self.image = nil
        queue.cancelAllOperations()
        progress?.startAnimating()
        if (!url.isEmpty) {
            queue.addOperation({self.downloadImg(url,cache:true)})
        }
    }
    
    // this method starts the download and sets the image with a given url
    func downloadImg(_ url : String, cache : Bool){
        var data: Data?
        
        // if the image is in the cache, uses it
        if(!cache){
            do{
                data = try Data(contentsOf: URL(string : url)!)
            } catch {
                print("error Download")
            }
        } else { // if it's not in the cache, download it and stores it in the cache
            var path = url.replace("/", with: "_")
            path = path.replace("\\", with: "_")
            path = path.replace(":", with: "_")
            path = NSHomeDirectory() + "/Documents/" + path
            let exists = FileManager.default.fileExists(atPath: path)
            if(exists){
                do {
                    data = try Data(contentsOf: URL(fileURLWithPath: path))
                } catch {
                    print("erro Download 2")
                }
            } else {
                data = try? Data(contentsOf: URL(string: url)!)
                if(data != nil){
                    //data.write(toFile: path, atomically:true
                    try! data?.write(to: URL(fileURLWithPath: path), options: .atomic)
                }
            }
        }
        if(data != nil){
            mainQueue.addOperation({self.showImg(data!, url: url)})
        }
    }
    
    func showImg(_ data:Data, url: String){
        // this is to avoid the racing condition when a image on another thread would replace the wrong one
        if let url_ = imgUrl{
            if(data.count > 0 && url_ == url && imgUrl != nil){
                self.image = UIImage(data: data)
                progress?.stopAnimating()
            }
        }
    }
}

extension String {
    func trim() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    func replace(_ of: String, with: String) -> String {
        let s = self.replacingOccurrences(of: of, with: with)
        return s
    }
    
    func url() -> URL {
        return URL(string: self)!
    }
}
