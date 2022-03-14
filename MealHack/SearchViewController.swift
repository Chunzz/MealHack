//
//  SearchViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 15/5/21.
//

import UIKit
import FirebaseAuth
import Firebase
class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    //Variables
    @IBOutlet weak var searchResults: UITableView!
    @IBOutlet weak var SearchBarContainer: UIView!

    let CELL_RECIPE = "recipeCell"
    let REQUEST_STRING = "https://api.spoonacular.com/recipes/complexSearch?apiKey=&number=10&addRecipeInformation=true&query="
    var indicator = UIActivityIndicatorView()
    var searchText = ""
    var newRecipes = [RecipeData]()
    var selectedRecipeId: Int?
    var selectedRecipeName: String?
    var searchController: UISearchController!
    var usersReference = Firestore.firestore().collection("users")

    func displayMessage(title: String, message:String)  {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table set up
        self.searchResults.delegate = self
        self.searchResults.dataSource = self
        self.searchResults.isHidden = true
        
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
        
        //Start search
        if !searchText.isEmpty{
            searchBar.text = searchText
            indicator.startAnimating()
            requestMeals(searchText)
        }
    }
    
    //Search text
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        newRecipes.removeAll()
        self.searchResults.reloadData()
        guard let searchText = searchBar.text else {return}
        indicator.startAnimating()
        requestMeals(searchText)
    }
    
    //Return to previous screen if empty
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        newRecipes.removeAll()
        self.searchResults.reloadData()
        guard let searchText = searchBar.text else {return}
        indicator.startAnimating()
        requestMeals(searchText)
    }
    
    //Go back
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
    
    //Update firestore with recent search
    func addRecentSearch(recentSearch: String){
        if recentSearch.isEmpty{
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "Error", message: "No user logged in!")
            return
        }
        
        let docRef = self.usersReference.document("\(userID)").collection("mealStats").document("recentSearches")

        docRef.getDocument{ (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var searchArray = snapshot!.get("searches") as! Array<String>
                
                if searchArray.contains(recentSearch){
                    return
                }
                if searchArray.count == 4 {
                    searchArray.remove(at: 0)
                }
                searchArray.append(recentSearch)
                self.usersReference.document("\(userID)").collection("mealStats").document("recentSearches").setData(["searches": searchArray])
            }
        }
    }
    
    //Select recipe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeId = newRecipes[indexPath.row].id!
        selectedRecipeName = newRecipes[indexPath.row].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newRecipes.count
    }
    
    //Row info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RECIPE, for: indexPath)
        cell.textLabel?.text = newRecipes[indexPath.row].title
        return cell
    }
    
    //Searching api for meals
    func requestMeals(_ searchInput: String){
        guard let queryString = searchInput.addingPercentEncoding(withAllowedCharacters:
                                                                    .urlQueryAllowed) else {
            print("Query string can't be encoded.")
            return
        }
        guard let requestURL = URL(string: REQUEST_STRING + queryString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            // This closure is executed on a different thread at a later point in
            // time!
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.addRecentSearch(recentSearch: searchInput)
            }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let rootData = try decoder.decode(SearchRootData.self, from: data!)
                if let recipes = rootData.recipes {
                    for recipe in recipes {
                        self.newRecipes.append(recipe)
                    }
                    DispatchQueue.main.async {
                        self.searchResults.isHidden = false
                        self.searchResults.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }

    
    //Prepare for meal creation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipePageSegue" {
            let destination = segue.destination as! RecipeViewController
            destination.selectedRecipeName = selectedRecipeName
            destination.selectedRecipeId = selectedRecipeId
        }
    }
}
