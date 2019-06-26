//
//  ViewController.swift
//  Hero
//
//  Created by Jesus Alberto Berlanga Reyes on 6/24/19.
//  Copyright © 2019 Jesus Alberto Berlanga Reyes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, ActivityIndicatorPresenter {

    @IBOutlet weak var MyCollectionView: UICollectionView!
    @IBOutlet weak var btnPress: UIButton!
    @IBOutlet weak var btnNextPage: UIButton!
    @IBOutlet weak var btnPreviousPage: UIButton!
    @IBOutlet weak var lblTotPok: UILabel!
    @IBOutlet weak var constraintTopView: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomView: NSLayoutConstraint!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var lblNombrePokemon: UILabel!
    @IBOutlet weak var btnClosePopUp: UIButton!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var lblType1: UILabel!
    @IBOutlet weak var lblType2: UILabel!
    @IBOutlet weak var lblType3: UILabel!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var nextUrl = String()
    var previousUrl = String()
    var count = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.layer.cornerRadius = 15
        viewPopUp.layer.cornerRadius = 15
        btnPreviousPage.layer.cornerRadius = 15
        btnNextPage.layer.cornerRadius = 15
        btnPress.layer.cornerRadius = 15
        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionView), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openPopUp), name: NSNotification.Name(rawValue: "openPopUp"), object: nil)
        webServices.shared.requestPOSTresponse(link: "pokemon/", VC: viewController!, linkComplete: "")
    }

    @IBAction func pressed(_ sender: UIButton) {
        links.link = "var" + "/"
        webServices.shared.requestPOSTresponse(link: "pokemon/", VC: viewController!, linkComplete: "")
    }
    
    //MARK: - DataTable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dictionaries.dictoMoves.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.TableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath) as! TableViewCellClass
        cell.lblMove.text = dictionaries.dictoMoves[indexPath.row]["move"]
        cell.lblMove.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        headerText.adjustsFontSizeToFitWidth = true
        headerText.textAlignment = .center
        headerText.text = "Movimientos de ataque"
        return headerText.text
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
        btnClosePopUp.alpha = 0.5
        showActivityIndicator()
        let name = dictionaries.dictoPokemon[indexPath.row]["name"]!
        links.link = "\(name)" + "/"
        webServices.shared.requestPOSTresponse(link: "pokemon/", VC: viewController!, linkComplete: "")
        return
    }
    
    //MARK: - Functions
    @objc func loadCollectionView(){
        count = dictionaries.dictoPokemonPage[0]["count"] as! String
        lblTotPok.text = "Total de pokemon \(count)"
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
        fillTypes()
        TableView.reloadData()
        moveScreenPopUp()
        lblNombrePokemon.text = dictionaries.dictoGenerals[0]["name"]
        var pesoString = dictionaries.dictoGenerals[0]["weight"] as! String
        pesoString = "Peso : \(pesoString)"
        lblPeso.text = pesoString
        var img = "front_shiny"
        for images in dictionaries.dictoImages{
            if let image = images["front_shiny"]{
                img = image
            }
        }
        imgPokemon.downloadedFrom(link: img)
        self.hideActivityIndicator()
    }
    
    func moveScreenPopUp(){
        constraintTopView.constant = 39
        constraintBottomView.constant = 20
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 1.6, animations: {
            self.btnClosePopUp.alpha = 0.5
            self.imgPokemon.isHidden = false
            self.lblPeso.isHidden = false
            self.lblNombrePokemon.isHidden = false
            self.TableView.isHidden = false
            self.lblType1.isHidden = false
            if self.lblType3.text != ""{
                self.lblType2.isHidden = false
                self.lblType3.isHidden = false
            }else if self.lblType2.text != ""{
                self.lblType2.isHidden = false
            }
        })
    }
    
    func fillTypes(){
        var i = 0
        while i < dictionaries.dictoType.count{
            switch i {
            case 0:
                let typeString = dictionaries.dictoType[i]["name"] as! String
                lblType1.text = "Tipo : \(typeString)"
            case 1:
                let typeString = dictionaries.dictoType[i]["name"] as! String
                lblType2.text = "Tipo : \(typeString)"
            case 2:
                let typeString = dictionaries.dictoType[i]["name"] as! String
                lblType3.text = "Tipo : \(typeString)"
            default:
                return
            }
            i += 1
        }
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
    
    @IBAction func closePopUp(_ sender: UIButton) {
        dictionaries.dictoGenerals.removeAll()
        dictionaries.dictoImages.removeAll()
        dictionaries.dictoMoves.removeAll()
        dictionaries.dictoType.removeAll()
        imgPokemon.image = nil
        constraintTopView.constant = -100
        constraintBottomView.constant = 900
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.6, animations: {
            self.btnClosePopUp.alpha = 0
            self.imgPokemon.isHidden = true
            self.lblPeso.isHidden = true
            self.lblNombrePokemon.isHidden = true
            self.TableView.isHidden = true
            self.lblType1.isHidden = true
            self.lblType2.isHidden = true
            self.lblType3.isHidden = true
            self.lblType1.text = ""
            self.lblType2.text = ""
            self.lblType3.text = ""
        })
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

