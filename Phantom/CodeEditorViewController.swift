//
//  CodeEditorViewController.swift
//  Phantom
//
//  Created by Joseph on 21/1/18.
//  Copyright © 2018 Joseph. All rights reserved.
//

import Foundation
import UIKit
import Highlightr
import Popover
import DropDown
import TVAlert
import SwiftyJSON
import SafariServices

class CodeEditorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    
    let animals: [String] = ["1", "2", "3", "4", "5"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var lineNumbers: UITableView!
    @IBOutlet weak var codeView: UITextView!
    @IBOutlet weak var viewPlaceholder: UIView!
    var textView : UITextView!
    var segment: UISegmentedControl!
    
    var code : String!

    @IBOutlet var textToolbar: UIToolbar!
    var highlightr : Highlightr!
    let textStorage = CodeAttributedString()
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "")
        
        if title == "Untitled" {
            
            textView.text = "Close Code Editor and Open a different File."
        } else {
            var file = UserDefaults.standard.string(forKey: String(sender.selectedSegmentIndex + 1))
            
            let token = file?.components(separatedBy: "Documents/")
            
            file = token?[1]
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent(file!)
                NSLog(String(describing: fileURL))
                
                //reading
                do {
                    code = try String(contentsOf: fileURL, encoding: .utf8)
                    textView.layer.frame.size.height = code.height(withConstrainedWidth: viewPlaceholder.frame.size.width, font: UIFont.systemFont(ofSize: 35.0)).height
                    textView.text = code
                }
                catch {
                    NSLog("some error")
                    textView.text = "ERROR!"
                }
            }
        }
        
        let filePath = UserDefaults.standard.value(forKey: String(sender.selectedSegmentIndex + 1))
        
        print("File Path is : \(filePath as! String)")
        print("File Number is : \(sender.selectedSegmentIndex + 1)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineNumbers.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        lineNumbers.delegate = self
        lineNumbers.dataSource = self
        
        if UserDefaults.standard.string(forKey: "2") != nil {
            if UserDefaults.standard.string(forKey: "1") == UserDefaults.standard.string(forKey: "2") {
                UserDefaults.standard.setValue("Untitled", forKey: "2")
                UserDefaults.standard.setValue("Untitled", forKey: "2Name")
            }
        } else {
            UserDefaults.standard.setValue("Untitled", forKey: "2")
            UserDefaults.standard.setValue("Untitled", forKey: "2Name")
        }
        autoreleasepool {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            DropDown.startListeningToKeyboard()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationItem.title =
            
            segment = UISegmentedControl(items: [UserDefaults.standard.string(forKey: "1Name") as Any, UserDefaults.standard.string(forKey: "2Name") as Any])
            segment.sizeToFit()
//            segment.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
            
            segment.selectedSegmentIndex = 0;
            
            segment.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        
            self.navigationItem.titleView = segment
            
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            
            var file = UserDefaults.standard.string(forKey: "currentFile")
            
            let token = file?.components(separatedBy: "Documents/")
            
            file = token?[1]
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent(file!)
                
                //reading
                do {
                    code = try String(contentsOf: fileURL, encoding: .utf8)
                }
                catch { NSLog("some error")}
            }
            
            let textContainer = NSTextContainer(size: code.height(withConstrainedWidth: viewPlaceholder.frame.size.width, font: UIFont.systemFont(ofSize: 35.0)))
            
            
            layoutManager.addTextContainer(textContainer)
            
            textView = UITextView(frame: viewPlaceholder.bounds, textContainer: textContainer)
            textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            textView.autocorrectionType = UITextAutocorrectionType.no
            textView.autocapitalizationType = UITextAutocapitalizationType.none
            textView.keyboardAppearance = UIKeyboardAppearance.dark

            viewPlaceholder.addSubview(textView)
            addToolBar(textView: textView)
            
            textView.text = code
            
            highlightr = textStorage.highlightr
            
            let pathExtention = file?.fileExtension().lowercased()
            
            if pathExtention == "html" {
                
                textStorage.language = "html"
                
            } else if pathExtention == "js" {
                
                textStorage.language = "javascript"
                
            } else if pathExtention == "css" {
                
                textStorage.language = "css"
                
            } else if pathExtention == "php" {
                
                textStorage.language = "php"
                
            }
            
            
            
//            textStorage.language = "HTML"
            
            
            
            highlightr.setTheme(to: UserDefaults.standard.string(forKey: "editorTheme")!)

            textView.backgroundColor = highlightr.theme.themeBackgroundColor
            lineNumbers.backgroundColor = highlightr.theme.themeBackgroundColor
            lineNumbers.sectionIndexBackgroundColor = highlightr.theme.themeBackgroundColor
            lineNumbers.sectionIndexTrackingBackgroundColor = highlightr.theme.themeBackgroundColor
        
            viewPlaceholder.backgroundColor = highlightr.theme.themeBackgroundColor
            navigationController?.navigationBar.barTintColor = highlightr.theme.themeBackgroundColor
            
            UserDefaults.standard.setColor(value: invertColor(color: (navigationController?.navigationBar.barTintColor)!), forKey: "TintColor")
            UserDefaults.standard.synchronize()
            
            navigationController?.navigationBar.tintColor = invertColor(color: highlightr.theme.themeBackgroundColor)
            
            UserDefaults.standard.setColor(value: navigationController?.navigationBar.barTintColor, forKey: "BGColor")
            UserDefaults.standard.synchronize()
            
            navigationController?.navigationBar.barStyle = UIBarStyle.black
            textView.isScrollEnabled = true
            self.autoSave()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let layoutManager:NSLayoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//            print(layoutManager.glyph(at: index).words)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        
        return numberOfLines
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.lineNumbers.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = String(indexPath.row + 1)
        cell.backgroundColor = highlightr.theme.themeBackgroundColor
        cell.textLabel?.textColor = invertColor(color: (navigationController?.navigationBar.barTintColor!)!)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        cell.textLabel?.font.withSize(10)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let t: String = "<!DOCTYPE html>"
        return t.height(withConstrainedWidth: viewPlaceholder.frame.size.width, font: UIFont.systemFont(ofSize: (textView.font?.pointSize)!)).height
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
    func invertColor(color: UIColor) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
    }
    

    @IBAction func exit(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "\(segment.selectedSegmentIndex + 1)_save") != "saved" {
//            let s: UISegmentedControlSegment = UISegmentedControlSegment(rawValue: segment.selectedSegmentIndex + 1)!
            
            if segment.selectedSegmentIndex != 1 {
                if segment.titleForSegment(at: segment.selectedSegmentIndex + 1)?.replacingOccurrences(of: " •", with: "") == "Untitled" {
                    let alertController = TVAlertController(title: "Wait!", message: "You haven't saved your open file!", preferredStyle: .alert)
                    
                    alertController.style = .dark
                    
                    let OKAction = TVAlertAction(title: "Save", style: .default) { (action) in
                        self.saveFileFunc()
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    
                    let cancelAction = TVAlertAction(title: "Cancel", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    let destroyAction = TVAlertAction(title: "Don't Save", style: .destructive) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(destroyAction)
                    
                    
                    self.present(alertController, animated: true) {
                        
                    }
                } else {
                    let alertController = TVAlertController(title: "Wait!", message: "You haven't saved the two open files!", preferredStyle: .alert)
                    
                    alertController.style = .dark
                    
                    let OKAction = TVAlertAction(title: "Save", style: .default) { (action) in
                        self.saveFileFunc()
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    
                    let cancelAction = TVAlertAction(title: "Don't Save", style: .cancel) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true) {
                        
                    }
                }
            } else {
                if UserDefaults.standard.string(forKey: "\(segment.selectedSegmentIndex - 1)_save") != "saved" {
                    let alertController = TVAlertController(title: "Wait!", message: "You haven't saved your open file!", preferredStyle: .alert)
                    
                    alertController.style = .dark
                    
                    let OKAction = TVAlertAction(title: "Save", style: .default) { (action) in
                        self.saveFileFunc()
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    
                    let cancelAction = TVAlertAction(title: "Cancel", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    let destroyAction = TVAlertAction(title: "Don't Save", style: .destructive) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(destroyAction)
                    
                    
                    self.present(alertController, animated: true) {
                        
                    }
                } else {
                    let alertController = TVAlertController(title: "Wait!", message: "You haven't saved the two open files!", preferredStyle: .alert)
                    
                    alertController.style = .dark
                    
                    let OKAction = TVAlertAction(title: "Save", style: .default) { (action) in
                        self.saveFileFunc()
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    
                    let cancelAction = TVAlertAction(title: "Don't Save", style: .cancel) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true) {
                        
                    }
                }
            }
            
        } else {
            if UserDefaults.standard.string(forKey: "1") == UserDefaults.standard.string(forKey: "2") {
                
            } else {
                UserDefaults.standard.setValue(UserDefaults.standard.string(forKey: "1"), forKey: "2")
                UserDefaults.standard.setValue(UserDefaults.standard.string(forKey: "1Name"), forKey: "2Name")
            }
            
            code = nil
            highlightr = nil
            textView = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func showCodeCompletion(_ sender: Any) {
        
    }
    
    func autoSave() {
        do {
            var filepath = ""
            if UserDefaults.standard.bool(forKey: "hasSession") {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                filepath = paths.appendingPathComponent("Session.everestx_session")
            } else {
                filepath = Bundle.main.path(forResource: "Session", ofType: "everestx_session")!
            }
            
            print(filepath)
            
            let jsonString = try String(contentsOfFile: filepath)
            
            if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                do {
                    
                    var json = try JSON(data: dataFromString)
                    
                    var openTitle = ""
                    var secondTitle = ""
                    
                    if segment.selectedSegmentIndex != 1 {
                        openTitle = segment.titleForSegment(at: segment.selectedSegmentIndex)!
                        openTitle = openTitle.replacingOccurrences(of: " •", with: "")
                        secondTitle = segment.titleForSegment(at: segment.selectedSegmentIndex + 1)!
                        secondTitle = secondTitle.replacingOccurrences(of: " •", with: "")
                    } else {
                        openTitle = segment.titleForSegment(at: segment.selectedSegmentIndex - 1)!
                        openTitle = openTitle.replacingOccurrences(of: " •", with: "")
                        secondTitle = segment.titleForSegment(at: segment.selectedSegmentIndex)!
                        secondTitle = secondTitle.replacingOccurrences(of: " •", with: "")
                    }
                    
                    if segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "") == openTitle {
                        
                        json["windows"][0]["buffers"][0]["name"].stringValue = openTitle
                        
                        json["windows"][0]["buffers"][0]["content"].stringValue = textView.text
                        
                        print("1")
                        
                        print(json["windows"][0]["buffers"][0]["name"])
                        
                        json["windows"][0]["buffers"][1]["name"].stringValue = secondTitle
                        
                        print("2")
                        
                        print(json["windows"][0]["buffers"][1]["name"])
                        
                    } else if segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "") == secondTitle {
                        json["windows"][0]["buffers"][0]["name"].stringValue = openTitle
                        
                        print("1")
                        
                        print(json["windows"][0]["buffers"][0]["name"])
                        
                        json["windows"][0]["buffers"][1]["name"].stringValue = secondTitle
                        
                        json["windows"][0]["buffers"][1]["content"].stringValue = textView.text
                        
                        print("2")
                        
                        print(json["windows"][0]["buffers"][1]["name"])
                    } else {
                        
                    }
                    
                    print(json)
                    
                    let file = "Session.everestx_session"
                    
                    let text = "\(json)"
                    
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        let fileURL = dir.appendingPathComponent(file)
                        
                        //writing
                        do {
                            try text.write(to: fileURL, atomically: false, encoding: .utf8)
                            UserDefaults.standard.set(true, forKey: "hasSession")
                        }
                        catch {/* error handling here */}
                        
                        //reading
                        do {
//                            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                        }
                        catch {
                        
                        }
                    }
                    
                } catch {
                    print("JSONERROR")
                    print(error)
                }
            }
        } catch {
            print("LOADERROR")
            print(error)
        }
    }
    
    @objc func indentWithTab() {
        if let range = self.textView.textRangeFromNSRange(range: self.textView.selectedRange){
            self.textView.replace(range, withText: "\t")
        }
    }
    
    @objc func codeComplete() {
//        let dropDown = DropDown()
//
//        // The view to which the drop down will appear on
//        dropDown.anchorView = self.navigationItem.rightBarButtonItems?.first // UIView or UIBarButtonItem
//
//        // The list of items to display. Can be changed dynamically
//        dropDown.dataSource = ["<!DOCTYPE html>", "<html></html>", "<head></head>"]
//
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
//            if let range = self.textView.textRangeFromNSRange(range: self.textView.selectedRange){
//                self.textView.replace(range, withText: item)
//            }
//        }
//
//        dropDown.show()
        let alertController = UIAlertController(title: "Code Completion", message: "Code Completion is in beta phase! Please forgive & report any bugs to us!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        { (action) in
            // ...
        }
        alertController.addAction(okAction)
        
        let tableViewController = UITableViewController()
        tableViewController.preferredContentSize = CGSize(width: 272, height: 176) // 4 default cell heights.
        tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 2)
//        tableViewController.tableView(tableViewController.tableView, cellForRowAt: )
//        let indexPath = tableViewController.tableView.indexPathForRow(at: )
        for item in tableViewController.tableView.visibleCells {
            print(item)
            item.textLabel?.text = "Item"
        }
        alertController.setValue(tableViewController, forKey: "contentViewController")
        
        self.present(alertController, animated: true)
        {
            // ...
        }
    }
    
    @objc func invertColor2(color: UIColor) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        URLCache.shared.removeAllCachedResponses()
        code = nil
        highlightr = nil
        textView = nil
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange (_ textView: UITextView) {
        // Your code here.
        UserDefaults.standard.setValue("unsaved", forKey: "\(segment.selectedSegmentIndex + 1)_save")
//        segment.setTitle("\(segment.titleForSegment(at: segment.selectedSegmentIndex) •", forSegmentAt: segment.selectedSegmentIndex)
        
        var currentTitle = segment.titleForSegment(at: segment.selectedSegmentIndex)
        segment.setTitle("\(currentTitle ?? "Untitled") •", forSegmentAt: segment.selectedSegmentIndex)
        
        currentTitle = segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "")
        
        segment.setTitle("\(currentTitle ?? "Untitled") •", forSegmentAt: segment.selectedSegmentIndex)
        
            
        self.autoSave()
//        print("===== Text:", textView.text)
    }
    
    @objc func saveFileFunc() {
        let segment: UISegmentedControl = self.navigationItem.titleView as! UISegmentedControl
        var seg = 0
        
        if segment.selectedSegmentIndex != 1 {
            seg = segment.selectedSegmentIndex + 1
        } else {
            if segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "") != "Untitled" {
                seg = segment.selectedSegmentIndex + 1
            } else {
                seg = segment.selectedSegmentIndex
            }
        }
        
        var file = UserDefaults.standard.string(forKey: String(seg))
        
        let token = file?.components(separatedBy: "Documents/")
        
        file = token?[1]
        
        var text = ""
        
        if segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "") == "Untitled" {
            do {
                var filepath = ""
                if UserDefaults.standard.bool(forKey: "hasSession") {
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                    filepath = paths.appendingPathComponent("Session.everestx_session")
                } else {
                    filepath = Bundle.main.path(forResource: "Session", ofType: "everestx_session")!
                }
                let jsonString = try String(contentsOfFile: filepath)
                
                if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        
                        
                        var json = try JSON(data: dataFromString)
                        text = json["windows"][0]["buffers"][seg - 1]["content"].stringValue
                        print("1")
                        
                        print(text)
                        
                    } catch {
                        print("JSONERROR")
                        print(error)
                    }
                }
            } catch {
                print("LOADERROR")
                print(error)
            }
        } else {
            text = textView.text
        }
    
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file!)
            
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                UserDefaults.standard.setValue("saved", forKey: "\(seg)_save")
                
                let currentTitle = segment.titleForSegment(at: seg - 1)?.replacingOccurrences(of: " •", with: "")
                
                segment.setTitle("\(currentTitle ?? "Untitled")", forSegmentAt: seg - 1)
            }
            catch {
                
            }
            
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func saveFile(_ sender: Any) {
        let segment: UISegmentedControl = self.navigationItem.titleView as! UISegmentedControl
        
        var seg = 0
        
        if segment.selectedSegmentIndex != 1 {
            seg = segment.selectedSegmentIndex + 1
        } else {
            if segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "") != "Untitled" {
                seg = segment.selectedSegmentIndex + 1
            } else {
                seg = segment.selectedSegmentIndex
            }
        }
        
        var file = UserDefaults.standard.string(forKey: String(seg))
        
        let token = file?.components(separatedBy: "Documents/")
        
        file = token?[1]
        
        var text = ""
        if segment.titleForSegment(at: segment.selectedSegmentIndex)?.replacingOccurrences(of: " •", with: "") == "Untitled" {
            
            do {
                var filepath = ""
                if UserDefaults.standard.bool(forKey: "hasSession") {
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                    filepath = paths.appendingPathComponent("Session.everestx_session")
                } else {
                    filepath = Bundle.main.path(forResource: "Session", ofType: "everestx_session")!
                }
                let jsonString = try String(contentsOfFile: filepath)
                
                if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        
                        
                        var json = try JSON(data: dataFromString)
                        text = json["windows"][0]["buffers"][seg - 1]["content"].stringValue
                        print("1")
                        
                        print(text)
                        
                    } catch {
                        print("JSONERROR")
                        print(error)
                    }
                }
            } catch {
                print("LOADERROR")
                print(error)
            }
        } else {
            text = textView.text
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file!)
            
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                UserDefaults.standard.setValue("saved", forKey: "\(seg)_save")
                
                let currentTitle = segment.titleForSegment(at: seg - 1)?.replacingOccurrences(of: " •", with: "")
                
                segment.setTitle("\(currentTitle ?? "Untitled")", forSegmentAt: seg - 1)
            }
            catch {
                
            }
           
        }
    }
    
    deinit {
        URLCache.shared.removeAllCachedResponses()
        code = nil
        highlightr = nil
        textView = nil
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // DISABLE BUTTONS
        
//        self.navigationItem.leftBarButtonItems?.first?.isEnabled = false
//
//        self.navigationItem.leftBarButtonItems?.last?.isEnabled = false
//
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // SET TINT ON BUTTONS

//        self.navigationItem.leftBarButtonItems?.first?.tintColor = UIColor.clear
//
//        self.navigationItem.leftBarButtonItems?.last?.tintColor = UIColor.clear
//
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        // CLEAR NAVBAR

        self.navigationItem.title = " "
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        // ENABLE BUTTONS
        
//        self.navigationItem.leftBarButtonItems?.first?.isEnabled = true
//
//        self.navigationItem.leftBarButtonItems?.last?.isEnabled = true
//
//        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        // SET TINT ON BUTTONS
        
//        self.navigationItem.leftBarButtonItems?.first?.tintColor = invertColor(color: (navigationController?.navigationBar.barTintColor!)!)
//
//        self.navigationItem.leftBarButtonItems?.last?.tintColor = invertColor(color: (navigationController?.navigationBar.barTintColor!)!)
//
//        self.navigationItem.rightBarButtonItem?.tintColor = invertColor(color: (navigationController?.navigationBar.barTintColor!)!)
        
        // SET NAVBAR TITLE
        
        self.navigationItem.title = UserDefaults.standard.string(forKey: "currentFileName")
    }
    
    @IBAction func preview(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.string(forKey: "masterServers") == "running" {
            let safariVC = SFSafariViewController(url: NSURL(string: "https://127.0.0.1/\(segment.titleForSegment(at: segment.selectedSegmentIndex) ?? "index.html")")! as URL)
            
            if #available(iOS 10.0, *) {
                safariVC.preferredBarTintColor = UserDefaults.standard.colorForKey(key: "BGColor")
                safariVC.preferredControlTintColor = UserDefaults.standard.colorForKey(key: "TintColor")
            } else {
                // Fallback on earlier versions
                safariVC.navigationController?.navigationBar.tintColor = UserDefaults.standard.colorForKey(key: "TintColor")
                safariVC.navigationController?.navigationBar.barTintColor = UserDefaults.standard.colorForKey(key: "BGColor")
            }
            
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        } else {
            let alertController = TVAlertController(title: "Oops!", message: "You haven't started the master servers! In order to preview, please start the master servers!", preferredStyle: .alert)
            
            alertController.style = .dark
            
            let OKAction = TVAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            let cancelAction = TVAlertAction(title: "Close", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true) {
                
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UITextView
{
    func textRangeFromNSRange(range:NSRange) -> UITextRange?
    {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location), let end = self.position(from: start, offset: range.length) else { return nil}
        
        
        
        return self.textRange(from: start, to: end)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return boundingBox.size
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    
    func fileName() -> String {
        
        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent {
            return fileNameWithoutExtension
        } else {
            return ""
        }
    }
    
    func fileExtension() -> String {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return ""
        }
    }
}

extension CodeEditorViewController: UITextViewDelegate {
    func addToolBar(textView: UITextView){
        let toolBar = UIToolbar()
        UserDefaults.standard.synchronize()
        toolBar.barStyle = UIBarStyle.black
//        toolBar.backgroundColor = UserDefaults.standard.colorForKey(key: "BGColor")
        toolBar.isTranslucent = true
        toolBar.tintColor = UserDefaults.standard.colorForKey(key: "TintColor")
        toolBar.barTintColor = UserDefaults.standard.colorForKey(key: "BGColor")
        let doneButton = UIBarButtonItem(image: UIImage.init(named: "save"), style: UIBarButtonItemStyle.done, target: self, action: #selector(CodeEditorViewController.saveFileFunc))
        let tabButton = UIBarButtonItem(image: UIImage.init(named: "select-column"), style: UIBarButtonItemStyle.done, target: self, action: #selector(CodeEditorViewController.indentWithTab))
//        let autoCompleteButton = UIBarButtonItem(image: UIImage.init(named: "SourceCode"), style: UIBarButtonItemStyle.done, target: self, action: #selector(CodeEditorViewController.codeComplete))
        let cancelButton = UIBarButtonItem(image: UIImage.init(named: "DropDown"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CodeEditorViewController.closeKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, tabButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.delegate = self
        textView.inputAccessoryView = toolBar
    }
    
}

extension UserDefaults {
    func setColor(value: UIColor?, forKey: String) {
        guard let value = value else {
            set(nil, forKey:  forKey)
            return
        }
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: forKey)
    }
    func colorForKey(key:String) -> UIColor? {
        guard let data = data(forKey: key), let color = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
            else { return nil }
        return color
    }
}
