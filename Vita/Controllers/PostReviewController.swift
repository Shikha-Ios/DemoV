//
//  PostReviewController.swift
//  Vita
//
//  Created by Gaurav Sharma on 8/3/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class PostReviewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var images_Collectionview: UICollectionView!
    
    @IBOutlet weak var emojies_CollectionView: UICollectionView!
    @IBOutlet weak var caption_txtView: UITextView!
    @IBOutlet weak var addEvent_txt: UITextField!
    @IBOutlet weak var background_img: UIImageView!
    
    
    @IBOutlet weak var fullImg_View: UIView!
    
    
    @IBOutlet weak var full_img: UIImageView!
    
    
    var selectItem = -1
    var tapImg = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImg_View.isHidden = true
        addEvent_txt.attributedPlaceholder = NSAttributedString(string: "Add Event Title...",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        applyPlaceholderStyle(aTextview: caption_txtView, placeholderText: "Write a caption ...")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Collection View Delegates

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == images_Collectionview{
        return CameraViewModel.sharedInstance.imageArray.count
        }
        else
        {
            return 7
        }
        
        
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.white
        aTextview.text = placeholderText
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == addEvent_txt{
//            if range.location == 0{
//                addEvent_txt.text = "Add Event Title..."
//            }
//        
//        }
//        return true
//    }
    func moveCursorToStart(aTextView: UITextView)
    {
        DispatchQueue.main.async(execute: {
            aTextView.selectedRange = NSMakeRange(0, 0);
        })
    }
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.white
        aTextview.alpha = 1.0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            
            if textView == caption_txtView && textView.text == "Write a caption ..."
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
               applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(aTextview: textView, placeholderText: "Write a caption ...")
            moveCursorToStart(aTextView: textView)
            return false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == images_Collectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell",
                                                          for: indexPath) as? ReviewImagesViewCell
            cell?.capture_img.image = CameraViewModel.sharedInstance.imageArray[indexPath.row]
            
             return cell!

        }
        else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell",
                                                          for: indexPath)
            if selectItem == indexPath.row{
                 cell.contentView.backgroundColor =  UIColor(red: 52/254, green: 180/254, blue: 196/254, alpha: 1)
            }
            else{
                cell.contentView.backgroundColor =  UIColor.clear
            }
             return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectItem = indexPath.row
        tapImg = indexPath.row
        if collectionView == emojies_CollectionView{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor =  UIColor(red: 52/255, green: 180/255, blue: 196/255, alpha: 1)
//            postNowBtn.setBackgroundImage(UIImage(named: "buttonBg"), for: .normal)
//            postNowBtn.backgroundColor = UIColor.clear
            
            collectionView.reloadData()
        }
        else{
        
        fullImg_View.isHidden = false
            full_img.image = CameraViewModel.sharedInstance.imageArray[indexPath.row]
        }
        
    }
    
    // MARK: UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            applyPlaceholderStyle(aTextview: textView, placeholderText: "Write a caption ...")
        }
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        caption_txtView.text = ""
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addEvent_txt.text = ""
    }
    
    
    //MARK: Action Methods
    
    @IBAction func crossBtn(_ sender: Any) {
        fullImg_View.isHidden = true
        
    }
    
    @IBOutlet weak var crossButton: UIButton!

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func postBtn(_ sender: Any) {
    }
    
    @IBAction func downloadImg_button(_ sender: Any) {
    }
    
    @IBAction func deleteImg_button(_ sender: Any) {
        CameraViewModel.sharedInstance.imageArray.remove(at: tapImg)
        images_Collectionview.reloadData()
        fullImg_View.isHidden = true
    
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
