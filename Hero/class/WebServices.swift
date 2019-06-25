//
//  WebServices.swift
//  Hero
//
//  Created by Jesus Alberto Berlanga Reyes on 6/24/19.
//  Copyright © 2019 Jesus Alberto Berlanga Reyes. All rights reserved.
//

import Foundation
import UIKit

class webServices: UIViewController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    //MARK: - Properties
    
    static let shared = webServices()
    public func requestPOSTresponse(link: String, VC: UIViewController, linkComplete: String){
        let linkString = link + links.link
        var urlString : String = String()
        var api : String = String()
        if link == ""{
            urlString = linkComplete
            api = "pokemon/"
        }else{
            urlString = "https://pokeapi.co/api/v2/\(linkString)"
            api = link
        }
        let url = URL(string: urlString)!
        if links.link != ""{
            api = link + "det"
        }
        URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Oups!!", message: "Oh Oh, algo salió mal", preferredStyle: UIAlertController.Style.alert)
                    let  FirstOption = UIAlertAction(title: "Ok", style:UIAlertAction.Style.default){ alertaction in
                    }
                    alert.addAction(FirstOption)
                    VC.present(alert, animated: true, completion: nil)
                }
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String:Any]
                switch api{
                //MARK: - pokemon/det
                case "pokemon/det":
                    links.link = ""
                    let respAbilities = responseJSON!["abilities"] as! [[String:Any]]
                    let respStats = responseJSON!["stats"] as! [[String:Any]]
                    let respHeldItems = responseJSON!["held_items"] as! [[String:Any]]
                    let respForms = responseJSON!["forms"] as! [[String:Any]]
                    let respGameIndices = responseJSON!["game_indices"] as! [[String:Any]]
                    let respSprites = responseJSON!["sprites"] as! [String:Any]
                    let respSpecies = responseJSON!["species"] as! [String:Any]
                    let respMoves = responseJSON!["moves"] as! [[String:Any]]
                    let respType = responseJSON!["types"] as! [[String:Any]]
                    let id = responseJSON!["id"] as! Int
                    let idString = String(id)
                    let exp = responseJSON!["base_experience"] as! Int
                    let expString = String(exp)
                    let height = responseJSON!["height"] as! Int
                    let heightString = String(height)
                    let weight = responseJSON!["weight"] as! Int
                    let weightString = String(weight)
                    let isDef = responseJSON!["is_default"] as! Bool
                    let isDefString = String(isDef)
                    let name = responseJSON!["name"] as! String
                    let order = responseJSON!["order"] as! Int
                    let orderString = String(order)
                    
                    dictionaries.dictoGenerals.append(["id":"\(idString)","exp":"\(expString)","height":"\(heightString)", "weight":"\(weightString)", "is_default":"\(isDefString)", "name":"\(name)","order":"\(orderString)"])
                    for jsonP in respAbilities{
                        let ability = jsonP["ability"] as! [String:Any]
                        let name = ability["name"] as! String
                        let url = ability["url"] as! String
                        let slot = jsonP["slot"] as! Int
                        let isHidden = jsonP["is_hidden"] as! Bool
                        let slotString = String(slot)
                        let isHiddenString = String(isHidden)
                        dictionaries.dictoAbilities.append(["name":"\(name)","url":"\(url)","slot":"\(slotString)", "isHidden":"\(isHiddenString)"])
                    }
                    for jsonP in respStats{
                        let stat = jsonP["stat"] as! [String:Any]
                        let name = stat["name"] as! String
                        let url = stat["url"] as! String
                        let base_stat = jsonP["base_stat"] as! Int
                        let base_statString = String(base_stat)
                        let effort = jsonP["effort"] as! Int
                        let effortString = String(effort)
                        dictionaries.dictoStats.append(["name":"\(name)","url":"\(url)","base_stat":"\(base_statString)", "effort":"\(effortString)"])
                    }
                    for jsonP in respHeldItems{
                        let item = jsonP["item"] as! [String:Any]
                        let url = item["url"] as! String
                        let name = item["name"] as! String
                        dictionaries.dictoVersionsTitle.append(["url":"\(url)", "name":"\(name)"])
                        let version_details = jsonP["version_details"] as! [[String:Any]]
                        for jsonDet in version_details{
                            let rarity = jsonDet["rarity"] as! Int
                            let rarityString = String(rarity)
                            let versionArray = jsonDet["version"] as! [String:Any]
                            let name = versionArray["name"] as! String
                            let url = versionArray["url"] as! String
                            dictionaries.dictoVersions.append(["rarity":"\(rarityString)", "name":"\(name)", "url":"\(url)"])
                        }
                        dictionaries.dictoWtDictoVersions.append(["Titles":"\(dictionaries.dictoVersionsTitle)", "Versiones":"\(dictionaries.dictoVersions)"])
                        
                    }
                    for jsonP in respForms{
                        let name = jsonP["name"] as! String
                        let url = jsonP["url"] as! String
                        dictionaries.dictoMain.append(["name":"\(name)", "url":"\(url)"])
                        
                    }
                    
                    for jsonP in respGameIndices{
                        let game_index = jsonP["game_index"] as! Int
                        let game_indexString = String(game_index)
                        let versions = jsonP["version"] as! [String:Any]
                        let name = versions["name"] as! String
                        let url = versions["url"] as! String
                        dictionaries.dictoIndx.append(["game_index":"\(game_indexString)", "name":"\(name)", "url":"\(url)"])
                    }
                    
                    for jsonP in respMoves{
                        let movements = jsonP["move"] as! [String: Any]
                        let move = movements["name"] as! String
                        let url = movements["url"] as! String
                        dictionaries.dictoMoves.append(["move":"\(move)","url":"\(url)"])
                    }
                    
                    for jsonP in respType{
                        let types = jsonP["type"] as! [String: Any]
                        let type = types["name"] as! String
                        let url = types["url"] as! String
                        dictionaries.dictoType.append(["name":"\(type)", "url":"\(url)"])
                    }
                    
                    for (key, value) in respSprites{
                        dictionaries.dictoImages.append(["\(key)":"\(value)"])
                    }
                    for (key, value) in respSpecies{
                        dictionaries.dictoSpecies.append(["\(key)":"\(value)"])
                    }
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openPopUp"), object: nil)
                    }
                //MARK: - pokemon/
                case "pokemon/":
                    let count = json["count"] as! Int
                    var next : String = String()
                    if json["next"] as? String != nil{
                        next = json["next"] as! String
                    }
                    
                    var previous : String = String()
                    if json["previous"] as? String != nil{
                        previous = json["previous"] as! String
                    }
                    
                    let results = json["results"] as! [[String: Any]]
                    for jsonP in results{
                        let name = jsonP["name"] as! String
                        let url = jsonP["url"] as! String
                        dictionaries.dictoPokemon.append(["name":"\(name)", "url":"\(url)"])
                    }
                    dictionaries.dictoPokemonPage.append(["count":"\(count)","next":"\(next)","previous":"\(previous)"])
                    print(dictionaries.dictoPokemon)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    }
                default:
                    return
                }
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    
}
