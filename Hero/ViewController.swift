//
//  ViewController.swift
//  Hero
//
//  Created by Jesus Alberto Berlanga Reyes on 6/24/19.
//  Copyright © 2019 Jesus Alberto Berlanga Reyes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ActivityIndicatorPresenter {

    @IBOutlet weak var MyCollectionView: UICollectionView!
    @IBOutlet weak var btnPress: UIButton!
    @IBOutlet weak var btnNextPage: UIButton!
    @IBOutlet weak var btnPreviousPage: UIButton!
    @IBOutlet weak var lblTotPok: UILabel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var nextUrl = String()
    var previousUrl = String()
    var count = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPreviousPage.layer.cornerRadius = 15
        btnNextPage.layer.cornerRadius = 15
        btnPress.layer.cornerRadius = 15
        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionView), name: NSNotification.Name(rawValue: "load"), object: nil)
        webServices.shared.requestPOSTresponse(link: "pokemon/", VC: viewController!, linkComplete: "")
    }

    @IBAction func pressed(_ sender: UIButton) {
        links.link = "var" + "/"
        webServices.shared.requestPOSTresponse(link: "pokemon/", VC: viewController!, linkComplete: "")
    }
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dictionaries.dictoPokemon.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        var url : String = String()
        url = dictionaries.dictoPokemon[indexPath.row]["url"]!
        cell.lblNamePok.text = dictionaries.dictoPokemon[indexPath.row]["name"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionsVertically = CGFloat(10)
        var collectionViewSize = self.view.frame.size
        collectionViewSize.width = (collectionViewSize.width)/2.0 //Display Two elements in a row.
        collectionViewSize.height = (collectionViewSize.height)/sectionsVertically
        return collectionViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showActivityIndicator()
        let name = dictionaries.dictoPokemon[indexPath.row]["name"]!
        links.link = "\(name)" + "/"
        webServices.shared.requestPOSTresponse(link: "pokemon/", VC: viewController!, linkComplete: "")
        return
    }
    
    //MARK: - Functions
    @objc func loadCollectionView(){
        count = dictionaries.dictoPokemonPage[0]["count"] as! String
        lblTotPok.text = "Toal de pokemon \(count)"
        let prev = dictionaries.dictoPokemonPage[0]["previous"]
        let next = dictionaries.dictoPokemonPage[0]["next"]
        MyCollectionView.reloadData()
        if prev != ""{
            btnPreviousPage.isHidden = false
        }else{
            btnPreviousPage.isHidden = true
        }
        if next != ""{
            btnNextPage.isHidden = false
        }else{
            btnNextPage.isHidden = true
        }
        DispatchQueue.main.async {
            self.hideActivityIndicator()
        }
    }
    
    @objc func openPopUp(){
        self.hideActivityIndicator()
    }
    
    //MARK: - BtnActions
    @IBAction func nextPage(_ sender: UIButton) {
        showActivityIndicator()
        nextUrl = dictionaries.dictoPokemonPage[0]["next"]! as! String
        dictionaries.dictoPokemonPage.removeAll()
        dictionaries.dictoPokemon.removeAll()
        webServices.shared.requestPOSTresponse(link: "" , VC: viewController!, linkComplete: nextUrl)
    }
    @IBAction func prevPage(_ sender: UIButton) {
        showActivityIndicator()
        previousUrl = dictionaries.dictoPokemonPage[0]["previous"] as! String
        dictionaries.dictoPokemonPage.removeAll()
        dictionaries.dictoPokemon.removeAll()
        webServices.shared.requestPOSTresponse(link: "", VC: viewController!, linkComplete: previousUrl)
    }
    
}
extension UIResponder {
    var viewController: UIViewController?{
        if let vc = self as? UIViewController {
            return vc
        }
        return next?.viewController
    }
}

