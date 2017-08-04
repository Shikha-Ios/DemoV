//
//  VitaUpdateViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 04/08/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class VitaUpdateViewController: UIViewController {

    @IBOutlet weak var collectionVC: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Action Methods
    @IBAction func backClicked(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func menuClicked(sender: UIButton){
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

extension VitaUpdateViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 14
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIndentifier", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let yourWidth = (self.collectionVC!.frame.width - (numberOfColumns - 1)) / numberOfColumns
        return CGSize(width: yourWidth, height: yourWidth)
    }
    
    
}
