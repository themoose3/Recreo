//
//  GalleryViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectView: UICollectionView!
    
    let photosArray: [UIImage] = [#imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "man"), #imageLiteral(resourceName: "girl"), #imageLiteral(resourceName: "filled-heart"), #imageLiteral(resourceName: "robot"), #imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "man"), #imageLiteral(resourceName: "girl"), #imageLiteral(resourceName: "filled-heart"), #imageLiteral(resourceName: "robot")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.delegate = self
        collectView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photo.image = photosArray[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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
