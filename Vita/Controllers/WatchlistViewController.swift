//
//  WatchlistViewController.swift
//  Vita
//
//  Created by Shemona.Puri on 04/08/17.
//  Copyright © 2017 Mobileprogramming. All rights reserved.
//

import UIKit

class WatchlistViewController: UIViewController {

    @IBOutlet var tableViewWatchList : UITableView!


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchlistViewController : UITableViewDataSource,UITableViewDelegate
{
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : WatchListDetailCell = tableView.dequeueReusableCell(withIdentifier: "WatchListDetailCell", for: indexPath) as! WatchListDetailCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "WatchListHeaderCell") as! WatchListHeaderCell
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    
}
extension WatchlistViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return 7
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIndentifier", for: indexPath)
            cell.backgroundColor = UIColor.black
            return cell
    }
}
