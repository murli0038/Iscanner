//
//  MainView.swift
//  Iscaner
//
//  Created by Nikunj Prajapati on 01/07/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import PDFKit
import CoreData
import YPImagePicker
import AVFoundation
import AVKit
import Photos
import CoreImage
import CoreImage.CIFilter
import PDFGenerator


class MainView: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIGestureRecognizerDelegate,UITabBarDelegate
{
    //MARK:- Variable Obj's
    
    let Mainimg: [UIImage] = []
    
    let pdfDocument = PDFDocument()
    
    var people: [NSManagedObject] = []
    
    var selectedItems = [YPMediaItem]()
    
    let imagePicker = UIImagePickerController()
    
    let viewController = UIViewController()
    
    var holdImg : UIImage!
    
    var manageContext: NSManagedObjectContext!
    
    var manageObjList: [NSManagedObject]!
    
    var tampArray: [UIImage] = []
    
    var arrScanDoc: [[String: Any]] = []
    
    var documents = Utilities.getDocuments()
    
    var pictureOrderNumber = 0
    
    
    //MARK: -IBOutlets
    
    @IBOutlet weak var lblDocCount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pickImageButton: UIImageView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    //MARK:- IBAction Functions
    
    @IBAction func gallarybtnpress(_ sender: Any)
    {
        var config = YPImagePickerConfiguration()
        
        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */
        
        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
        //                 config.library.onlySquare = true
        
        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
        config.onlySquareImagesFromCamera = false
        
        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
         resized to fit in a 1024x1024 box. Defaults to original image size. */
        // config.targetImageSize = .cappedTo(size: 1024)
        
        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photoAndVideo
        
        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
        config.usesFrontCamera = true
        
        /* Adds a Filter step in the photo taking process. Defaults to true */
        //                 config.showsFilters = false
        
        /* Manage filters by yourself */
        config.filters = [YPFilter(name: "Normal", coreImageFilterName: ""),
                          YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
                          YPFilter(name: "Noir", coreImageFilterName: "CIPhotoEffectNoir"),
                          YPFilter(name: "Fade", coreImageFilterName: "CIPhotoEffectFade"),
                          YPFilter(name: "Tonal", coreImageFilterName: "CIPhotoEffectTonal"),
                          YPFilter(name: "Clarendon", applier: YPFilter.clarendonFilter),
                          YPFilter(name: "HazeRemoval", applier: YPFilter.hazeRemovalFilter),
                          YPFilter(name: "Linear", coreImageFilterName: "CISRGBToneCurveToLinear"),
                          YPFilter(name: "MonoChrome", coreImageFilterName: "CIColorMonochrome"),
                          YPFilter(name: "Transfer", coreImageFilterName: "CIPhotoEffectTransfer"),
                          YPFilter(name: "SepiaTone", coreImageFilterName: "CISepiaTone"),
                          YPFilter(name: "Process", coreImageFilterName: "CIPhotoEffectProcess"),
                          YPFilter(name: "ColorControls", coreImageFilterName: "CIColorControls"),
                          YPFilter(name: "1977", applier: YPFilter.apply1977Filter),
                          YPFilter(name: "Clarendon", applier: YPFilter.clarendonFilter),
                          YPFilter(name: "HazeRemoval", applier: YPFilter.hazeRemovalFilter),]
        
        
        //                config.filters.remove(at: 1)
        //                config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)
        //        config.filters.insert(YPFilter(name: "CISepiaTone", coreImageFilterName: "CISepiaTone"), at: 1)
        //        config.filters.insert(YPFilter(name: "CIColorControls", coreImageFilterName: "CIColorControls"), at:1)
        
        /* Enables you to opt out from saving new (or old but filtered) images to the
         user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = false
        
        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality
        
        /* Defines the name of the album when saving pictures in the user's photo library.
         In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        config.albumName = "ThisIsMyAlbum"
        
        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
         Default value is `.photo` */
        config.startOnScreen = .library
        
        /* Defines which screens are shown at launch, and their order.
         Default value is `[.library, .photo]` */
        config.screens = [.library, .photo, .video]
        
        /* Can forbid the items with very big height with this property */
        //        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8
        
        /* Defines the time limit for recording videos.
         Default is 30 seconds. */
        // config.video.recordingTimeLimit = 5.0
        
        /* Defines the time limit for videos from the library.
         Defaults to 60 seconds. */
        config.video.libraryTimeLimit = 500.0
        
        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
        config.showsCrop = .rectangle(ratio: (2/3))
        
        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView
        
        /* Customize wordings */
        config.wordings.libraryTitle = "Gallery"
        
        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = false
        
        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false
        
        config.maxCameraZoomFactor = 2.0
        
        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false
        
        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
        //        config.library.minNumberOfItems = 2
        
        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true
        
        /* Here we use a per picker configuration. Configuration is always shared.
         That means than when you create one picker with configuration, than you can create other picker with just
         let picker = YPImagePicker() and the configuration will be the same as the first picker. */
        
        
        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        //options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options
        
        config.library.preselectedItems = selectedItems
        
        let picker = YPImagePicker(configuration: config)
        
        /* Change configuration directly */
        //                 YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"
        
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.holdImg = photo.image
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.holdImg = video.thumbnail
                    
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                        self?.present(playerVC, animated: true, completion: nil)
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }
        
        /* Single Photo implementation. */
        picker.didFinishPicking { [unowned picker] items, _ in
            self.selectedItems = items
            self.holdImg = items.singlePhoto?.image
            picker.dismiss(animated: true, completion: nil)
        }
        
        /* Single Video implementation. */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled { picker.dismiss(animated: true, completion: nil); return }
            
            self.selectedItems = items
            //                    self.mainImage.image = items.singleVideo?.thumbnail
            self.holdImg = items.singlePhoto?.image
            
            ///Saving image to coredata 2 lines
            
            self.tampArray.append(self.holdImg)
            self.save(image: self.tampArray)
            self.tableView.reloadData()
            
            ///finish here database code
            picker.dismiss(animated: true, completion: nil)
            
            //            let assetURL = items.singleVideo!.url
            //            let playerVC = AVPlayerViewController()
            //            let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
            //            playerVC.player = player
            //
            //            picker.dismiss(animated: true, completion: { [weak self] in
            //                self?.present(playerVC, animated: true, completion: nil)
            //                print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
            //            })
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func tapGesturetapped(_ sender: UITapGestureRecognizer)
    {
        camera()
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.reloadData()
        
        self.imageCircle()
        imagePicker.delegate = self
        pickImageButton.layer.cornerRadius = self.accessibilityFrame.size.width / 2
        pickImageButton.clipsToBounds = true
        
        
        self.manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let arrScanedDocs = (UserDefaults.standard.value(forKey: "ScanedDocs")) as? [[String: Any]], arrScanedDocs.count > 0 {
            
            self.arrScanDoc = arrScanedDocs
            self.lblDocCount.text = "All Docs (\(self.arrScanDoc.count))"
            self.tableView.reloadData()
            
        }
    }
    
//    (\(self.arrScanDoc.count)
    
    //MARK: -imageCircle Func
    func imageCircle()
    {
        pickImageButton.layer.borderWidth = 0
        pickImageButton.layer.masksToBounds = false
        pickImageButton.layer.borderColor = UIColor.init(red: 25, green: 34, blue: 251, alpha: 1).cgColor
        pickImageButton.layer.cornerRadius = pickImageButton.frame.height/2
        pickImageButton.clipsToBounds = true
    }
    
    
    //MARK: -Open Camera Func
    func camera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            
            //make function call here for visionkit
            configDocs()
            
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    //MARK: -Open Library Func
    func photoLibrary()
    {
        
        //
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    //MARK: -ImagePickerDelegate Funcs
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        //cancel button
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any])
    {
        //to take image in image-view
        holdImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        //   holdingImageView.image = holdImg
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     Get the new view controller using segue.destination.
     Pass the selected object to the new view controller.
     }
     */
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //    {
    //        guard let cameraPick = segue.destination as? cameraPick
    //    }
    
}



//MARK: - VNDocumentCameraViewControllerDelegate
extension MainView: VNDocumentCameraViewControllerDelegate
{
    private func configDocs()
    {
        let scaninngDoc = VNDocumentCameraViewController()
        scaninngDoc.delegate = self
        self.present(scaninngDoc, animated: true, completion: nil)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        
        for pageNumber in 0..<scan.pageCount
        {
            print("print image saving processing start")
            let image = scan.imageOfPage(at: pageNumber)
            
            self.tampArray.append(image)
            tableView.reloadData()
            
            print("image saved complete")
            
            if scan.pageCount == 1 {
                
                self.save(image: self.tampArray)
                tableView.reloadData()
                
            } else if pageNumber == scan.pageCount - 1 {
                
                self.save(image: self.tampArray)
                tableView.reloadData()
                
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: -Save Image func
    func save(image: [UIImage])
    {
        print(image.count)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        var arrImageURL: [String] = []
        
        for i in 0..<image.count {
            
            let fileName = "\(Date().timeIntervalSince1970).png"
            
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            if let data = (image[i]).jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    
                    arrImageURL.append(fileURL.absoluteString)
                    
                } catch {
                    print("error saving file:", error)
                }
            }
        }
        
        let dic: [String: Any] = ["id": "\(Date().timeIntervalSince1970)",
            "image": arrImageURL,
            "title": "iScan \(Date().timeIntervalSince1970)"]     //(\(self.arrScanDoc.count + 1))
        
        self.arrScanDoc.insert(dic, at: 0)
        self.lblDocCount.text = "All Docs (\(self.arrScanDoc.count))"
        UserDefaults.standard.set(self.arrScanDoc, forKey: "ScanedDocs")
        UserDefaults.standard.synchronize()
        
    }
}


//MARK: -TableViewDatasource and delegates
extension MainView: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrScanDoc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ImageTableViewCell
        
        let cellObject = self.arrScanDoc[indexPath.row]
        
        if let images = cellObject["image"] as? [String], images.count > 0
        {
            //store image in cell
            cell?.storedImage.image = self.urlToImage(imagePath: images[0])
        }
        
        cell?.imglbl.text = (cellObject["title"] as? String ?? "IScanner.\(indexPath.row)")
        
        
        cell?.storedImage.clipsToBounds = false
        cell?.storedImage.layer.shadowColor = UIColor.black.cgColor
        cell?.storedImage.layer.shadowOpacity = 0.5
        cell?.storedImage.layer.shadowOffset = CGSize.zero
        cell?.storedImage.layer.shadowRadius = 6
        cell?.storedImage.layer.shadowPath = UIBezierPath(roundedRect: (cell?.storedImage.bounds)!, cornerRadius: 10).cgPath
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.01 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
    
    
    func shareDocument(documentPath: String) {
          if FileManager.default.fileExists(atPath: documentPath){
              let fileURL = URL(fileURLWithPath: documentPath)
              let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
              activityViewController.popoverPresentationController?.sourceView=self.view
              present(activityViewController, animated: true, completion: nil)
          }
          else {
              print("Document was not found")
          }
      }
    func generatePDF(imagePath: String, pdfName: String) {
        let page1 = PDFPage.imagePath(imagePath)
        let pages = [page1]
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("\(pdfName).pdf")

        do {
            try PDFGenerator.generate(pages, to: docURL, dpi: .dpi_300)
            showAlertWith(title: "Saved!", message: "Your image has been saved as PDF.")
            print(docURL)
        } catch (let e) {
            showAlertWith(title: "Save error", message: "Error saving as PDF.")
            print(e)
        }
    }
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if let firstViewController = self.navigationController?.viewControllers.first {
                self.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true) {
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { action in
            self.dismiss(animated: true) {
            }
            DispatchQueue.main.async {
                self.shareDocument(documentPath: self.documents[self.pictureOrderNumber].path)
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Export to Photo Album", style: .default, handler: { action in
            if let image = UIImage(contentsOfFile: self.documents[self.pictureOrderNumber].path) {
             //   MyAwesomeAlbum.shared.save(image: image)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.showAlertWith(title: "Saved!", message: "Your image has been saved to your Photo Album.")
            }
            self.dismiss(animated: true) {
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Generate PDF", style: .default, handler: { action in
            var documentTitle = self.documents[self.pictureOrderNumber].path.components(separatedBy: "Documents/")[1]
            documentTitle = String(Array(documentTitle)[0..<(documentTitle.count-4)])
            let imagePath = self.documents[self.pictureOrderNumber].path
            self.generatePDF(imagePath: imagePath, pdfName: documentTitle)
            self.dismiss(animated: true) {
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            do {
                let filePath = self.documents[self.pictureOrderNumber]
                try FileManager.default.removeItem(at: filePath)

                if let firstViewController = self.navigationController?.viewControllers.first {
                    self.navigationController?.popToViewController(firstViewController, animated: true)
                }
            } catch {
                print("Delete error")
            }
        }))

        present(actionSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexpath) in
            
            tableView.beginUpdates()
            
            self.arrScanDoc.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.arrScanDoc, forKey: "ScanedDocs")
            tableView.endUpdates()
            self.lblDocCount.text = "All Docs (\(self.arrScanDoc.count))"
            
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "Rename") { (rowAction, indexpath) in
            
            self.addNewNameAlert(index: indexPath.row)
            
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return [deleteAction, addAction]
    }
    
    func addNewNameAlert(index: Int)
    {
        
        let alert = UIAlertController(title: "New Name", message: "Add a name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            [unowned self] action in
            let textName = alert.textFields?.first
            
            var dic = self.arrScanDoc[index]
            
            dic.updateValue(textName!.text!, forKey: "title")
            
            self.arrScanDoc.remove(at: index)
            self.arrScanDoc.insert(dic, at: index)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.arrScanDoc, forKey: "ScanedDocs")
            
            self.tableView.reloadData()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        
    }


    //MARK: -viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate
            else{
                return
        }
        let manageContext = appdelegate.persistentContainer.viewContext
        
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Image")
        
        do
        {
            people = try manageContext.fetch(fetchReq)
        }
        catch let error as NSError
        {
            print("data is not saved \(error),\(error.userInfo)")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    
    func urlToImage(imagePath: String) -> UIImage {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath = paths.first {
            
            let imageName = imagePath.components(separatedBy: "/")
            
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName.last!)
            
            return UIImage(contentsOfFile: imageURL.path)!
            
        } else {
            
            return UIImage()
            
        }
    }
    
}


//MARK: -extensions for YPImagePicker
extension MainView {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}
