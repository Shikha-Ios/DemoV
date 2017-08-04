//
//  ReviewController.swift
//  Vita
//
//  Created by Gaurav Sharma on 8/2/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class ReviewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var common_bg: UIImageView!
    @IBOutlet weak var postNowBtn: UIButton!
    @IBOutlet weak var emojisCollectionView: UICollectionView!
     var cameraViewModel = CameraViewModel()
    var selectItem = -1
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        //layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        layout.itemSize = CGSize(width: 40, height: 40)
//        //layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 10
//        emojisCollectionView!.collectionViewLayout = layout
        
        
     postNowBtn.isEnabled = false
        print(CameraViewModel.sharedInstance.imageArray)

        self.common_bg.image = CameraViewModel.sharedInstance.imageArray.last
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 20
//        
//    }
    
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
    }
    
    //3
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath)
        if indexPath.row == selectItem{
        cell.contentView.backgroundColor =  UIColor(red: 52/255, green: 180/255, blue: 196/255, alpha: 1)
        }
        else
        {
        cell.contentView.backgroundColor =  UIColor.clear
        }
    
       // cell.backgroundColor = UIColor.black
        return cell

    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postNowBtn.isEnabled = true
        selectItem = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath)
        cell.contentView.backgroundColor =  UIColor(red: 52/255, green: 180/255, blue: 196/255, alpha: 1)
        postNowBtn.setBackgroundImage(UIImage(named: "buttonBg"), for: .normal)
        postNowBtn.backgroundColor = UIColor.clear
        
        collectionView.reloadData()
        
        
    }
  

    
    @IBAction func crossButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func reviewButton(_ sender: Any) {
    }
    
    
    @IBAction func postNowButton(_ sender: Any) {
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
