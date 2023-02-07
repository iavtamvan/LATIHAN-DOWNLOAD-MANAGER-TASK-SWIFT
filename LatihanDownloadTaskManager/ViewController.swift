//
//  ViewController.swift
//  LatihanDownloadTaskManager
//
//  Created by Ade Fajr Ariav on 07/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttonStopView: UIButton!
    @IBOutlet var buttonView: UIButton!
    @IBOutlet var messageView: UILabel!
    @IBOutlet var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        messageView.text = "Ready"
        progressView.isHidden = false
        
        DownloadManager.shared.progress = { (totalBytesWritten, totalBytesExpectedToWrite) in
            let totalMB = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .binary)
            let writtenMB = ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .binary)
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.async {
                self.buttonView.isEnabled = false
                self.progressView.isHidden = false
                self.progressView.progress = progress
                self.messageView.text = "Downloading \(writtenMB) of \(totalMB)"
            }
        }
        
        DownloadManager.shared.completed = { (location) in
            
            try? FileManager.default.removeItem(at: location)
            
            DispatchQueue.main.async {
                self.messageView.text = "Download Finished"
                self.buttonView.isEnabled = true
            }
        }
        
        DownloadManager.shared.downloadError = { (task, error) in
            print("Task Completed: \(task), error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    @IBAction func buttonView(_ sender: Any) {
        let url = URL(string: "http://212.183.159.230/50MB.zip")
        let task = DownloadManager.shared.session.downloadTask(with: url!)
        task.resume()
    }
    
    @IBAction func buttonStopView(_ sender: Any) {
        
    }
}

