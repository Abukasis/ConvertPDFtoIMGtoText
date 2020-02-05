// PDFReader Class 

import Foundation
import UIKit
import Vision
import AVFoundation
import PDFKit


class PDFReader{
    init() {
        
    }
    var pdf : PDFView = PDFView()
    var image : UIImage = UIImage()
    var fullText: String = " "
        
    func readfullTextAloud(){
    
        let string = fullText
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        print(synth.isSpeaking)
    }
    func writeImageTextToSelf() {
        let detectText =  VNRecognizeTextRequest { (req, error) in
            var list = req.results
            list = list.map({$0 as? [VNRecognizedTextObservation]})!
            
            for item in list!{
                let textObserv = item as? VNRecognizedTextObservation
                let text = textObserv?.topCandidates(1)
                let myString:String = (text?[0].string) ?? " "
                self.fullText.append((myString) + " ")
                print("appended: " + myString)
            }    
        }
        
        var vn = [VNRequest]()   
        vn = [detectText]
        let imageRequestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try imageRequestHandler.perform( vn)
        }catch{
            print("Could not Read Image")
        }
    }

    func drawPDFfromURL(url: URL) {
        let document = CGPDFDocument(url as CFURL)
        let page = document!.page(at: 1)

        let pageRect = page!.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page!)
        }

        image = img
    }
    
}
