//
//  PostReviewController.swift
//  Vita
//
//  Created by Gaurav Sharma on 8/3/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class PostReviewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var images_Collectionview: UICollectionView!
    
    @IBOutlet weak var emojies_CollectionView: UICollectionView!
    @IBOutlet weak var caption_txtView: UITextView!
    @IBOutlet weak var addEvent_txt: UITextField!
    @IBOutlet weak var background_img: UIImageView!
    
    
    @IBOutlet weak var fullImg_View: UIView!
    
    
    @IBOutlet weak var full_img: UIImageView!
    
    
    var selectItem = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImg_View.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == images_Collectionview{
        return CameraViewModel.sharedInstance.imageArray.count
        }
        else
        {
            return 7
        }
        
        
    }
    
    //3
    
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
        
        
        // cell.backgroundColor = UIColor.black
       
        
    }
    //52, 180, 196
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectItem = indexPath.row
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
    
    
    
    
    @IBAction func crossBtn(_ sender: Any) {
        fullImg_View.isHidden = true
        
    }
    
    @IBOutlet weak var crossButton: UIButton!

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func postBtn(_ sender: Any) {
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
