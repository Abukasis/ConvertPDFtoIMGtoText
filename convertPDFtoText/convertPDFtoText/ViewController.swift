//
//  ViewController.swift
//  convertPDFtoText
//
//  Created by Oliver on 2/1/20.
//  Copyright © 2020 Addie. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var fileLabel: NSTextField!
    @IBOutlet weak var imageView2: NSImageView!
    
 
    @IBOutlet weak var textView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func uploadPDF(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a pdf file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["pdf"];

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                fileLabel.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    @IBAction func convertPDFtoText(_ sender: Any) {
        
        DispatchQueue.main.async {
            
        
        
        let pdfReader = PDFReader()
        
            pdfReader.pdfToImage(PDFPath: self.fileLabel!.stringValue as NSString)
            self.imageView.image = pdfReader.image[0]
            
            pdfReader.readImageText()
           
            self.textView.documentView?.insertText(pdfReader.fullText)
        }
    }
    
}

