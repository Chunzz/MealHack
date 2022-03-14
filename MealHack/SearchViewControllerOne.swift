//
//  SearchViewControllerOne.swift
//  MealHack
//
//  Created by Chun Long Fong on 15/5/21.
//

import UIKit
import FirebaseAuth
import Firebase
class SearchViewControllerOne: UIViewController, UISearchBarDelegate {
    //Variables
    @IBOutlet weak var DynamicSearchContainer: UIView!
    @IBOutlet weak var recentOne: UIButton!
    @IBOutlet weak var recentTwo: UIButton!
    @IBOutlet weak var recentThree: UIButton!
    @IBOutlet weak var recentFour: UIButton!
    @IBOutlet weak var popularOne: UIButton!
    @IBOutlet weak var popularTwo: UIButton!
    @IBOutlet weak var popularThree: UIButton!
    @IBOutlet weak var popularFour: UIButton!
    @IBAction func popularOneButton(_ sender: Any) {
        shortcutSearch(searchText: popularOne.title(for: .normal)!)
    }
    
    @IBAction func popularTwoButton(_ sender: Any) {
        shortcutSearch(searchText: popularTwo.title(for: .normal)!)
    }
    
    @IBAction func popularThreeButton(_ sender: Any) {
        shortcutSearch(searchText: popularThree.title(for: .normal)!)
    }
    
    @IBAction func popularFourButton(_ sender: Any) {
        shortcutSearch(searchText: popularFour.title(for: .normal)!)
    }
    
    @IBAction func recentOneButton(_ sender: Any) {
        shortcutSearch(searchText: recentOne.title(for: .normal)!)
    }
    
    @IBAction func recentTwoButton(_ sender: Any) {
        shortcutSearch(searchText: recentTwo.title(for: .normal)!)
    }
    
    @IBAction func recentThreeButton(_ sender: Any) {
        shortcutSearch(searchText: recentThree.title(for: .normal)!)
    }
    
    @IBAction func recentFourButton(_ sender: Any) {
        shortcutSearch(searchText: recentFour.title(for: .normal)!)
    }
    
    @IBOutlet weak var SearchBarContainer: UIView!
    var searchController: UISearchController!
    let testArray = ["one","two", "three"]
    var searchTextToSend = ""
    
    var selectedRecipeId: Int?
    var selectedRecipeName: String?
    var usersReference = Firestore.firestore().collection("users")
    var indicator = UIActivityIndicatorView()

    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update recent search
        getRecentSearches()
    }
    
    //Get recent search from firebase
    func getRecentSearches() {
        indicator.startAnimating()
        DynamicSearchContainer.isHidden = true
        
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "Error", message: "No user logged in!")
            return
        }
        
        let docRef = self.usersReference.document("\(userID)").collection("mealStats").document("recentSearches")
        
        docRef.getDocument{ (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let searchArray = snapshot!.get("searches") as! Array<String>
                
                if searchArray.indices.contains(0) {
                    self.recentOne.isHidden = false
                    self.recentOne.setTitle(searchArray[0], for: .normal)
                } else {
                    self.recentOne.isHidden = true
                }
                
                if searchArray.indices.contains(1) {
                    self.recentTwo.isHidden = false
                    self.recentTwo.setTitle(searchArray[1], for: .normal)
                } else {
                    self.recentTwo.isHidden = true
                }
                
                if searchArray.indices.contains(2) {
                    self.recentThree.isHidden = false
                    self.recentThree.setTitle(searchArray[2], for: .normal)
                } else {
                    self.recentThree.isHidden = true
                }
                
                if searchArray.indices.contains(3) {
                    self.recentFour.isHidden = false
                    self.recentFour.setTitle(searchArray[3], for: .normal)
                } else {
                    self.recentFour.isHidden = true
                }
                
                self.indicator.stopAnimating()
                self.DynamicSearchContainer.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Search bar set up
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search recipe..."
        searchBar.tintColor = UIColor.lightGray
        searchBar.barTintColor = UIColor.lightGray
        searchBar.isTranslucent = true
        searchBar.showsCancelButton = true
        var searchBarFrame = searchBar.frame
        searchBarFrame.size.width = self.SearchBarContainer.frame.size.width
        searchBar.frame = searchBarFrame
        searchBar.becomeFirstResponder()
        self.SearchBarContainer.addSubview(searchBar)
        
        //Indicator set up
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        getRecentSearches()
    }
    
    func shortcutSearch(searchText: String){
        //Start search process
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.searchText = searchText
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //Go to search view
        guard let searchText = searchBar.text else {return}
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.searchText = searchText
        searchBar.text = ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Go back to main screen
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegueTwo" {
            let destination = segue.destination as! SearchViewController
            destination.searchText = searchTextToSend
        }
        
        if segue.identifier == "recipePageSegue" {
            let destination = segue.destination as! RecipeViewController
            destination.selectedRecipeName = selectedRecipeName
            destination.selectedRecipeId = selectedRecipeId
        }
    }
}
