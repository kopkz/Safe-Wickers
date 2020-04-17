//
//  SearchCollectionViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 17/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "activityCell"
private var sectionInsets = UIEdgeInsets()
private let itemsPerRow: CGFloat = 3


class SearchCollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var searchNavigationItem: UINavigationItem!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    var activities = [Activities]()
    var activtyName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.backgroundColor = UIColor(red:0.27, green:0.45, blue:0.58, alpha:1)
        createDefaultActivities()
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self

        sectionInsets = UIEdgeInsets(top: 5.0, left: view.bounds.width/20, bottom: 5.0, right: view.bounds.width/20)
        print(view.bounds.width,sectionInsets)
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
        let activty = activities[indexPath.row]
        
            activityCell.activityImageView.image = UIImage(named: activty.imageName)
                //?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            activityCell.activityNameLabel.text = activty.activityName
    
        // Configure the cell
    
        return activityCell
    }

//     MARK: UICollectionViewDelegate
//Uncomment this method to specify if the specified item should be highlighted during tracking
    
     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool{
//        let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
//        activityCell.isHighlighted = true
        
        return true
    }
    

    
     //Uncomment this method to specify if the specified item should be selected
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
        activityCell.isSelected = true
        
        activtyName = activities[indexPath.row].activityName
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
        activityCell.isSelected = false
        
        activtyName = nil
    }
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
//        IndexPath) -> CGSize {
//        return CGSize(width: 80, height: 115)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout, insetForSectionAt
//        section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //return activityCollectionView.frame.width/20
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAt
        section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    

    /*
     Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    @IBAction func currentLocationButton(_ sender: Any) {
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
    }
    
    func createDefaultActivities(){
        activities.append(Activities(imageName: "icons8-swimmer-96.png", activityName: "Swimming"))
        activities.append(Activities(imageName: "icons8-surf-96.png", activityName: "Surfing"))
        activities.append(Activities(imageName: "icons8-row-boat-96.png", activityName: "Boating"))
    }
    
    
}
