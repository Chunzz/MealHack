//
//  Home2ViewController.swift
//  MealHack
//
//  Created by Chun Long Fong on 13/5/21.
//

import UIKit

class Home2ViewController: UIViewController, UISearchBarDelegate{
    //Variables
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var SearchBarContainer: UIView!
    @IBAction func recipeOneButton(_ sender: Any) {
        selectedRecipeId = newRecipes[0].id!
        selectedRecipeName = newRecipes[0].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeTwoButton(_ sender: Any) {
        selectedRecipeId = newRecipes[1].id!
        selectedRecipeName = newRecipes[1].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeThreeButton(_ sender: Any) {
        selectedRecipeId = newRecipes[2].id!
        selectedRecipeName = newRecipes[2].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeFourButton(_ sender: Any) {
        selectedRecipeId = newRecipes[3].id!
        selectedRecipeName = newRecipes[3].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeFiveButton(_ sender: Any) {
        selectedRecipeId = newRecipes[4].id!
        selectedRecipeName = newRecipes[4].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeSixButton(_ sender: Any) {
        selectedRecipeId = newRecipes[5].id!
        selectedRecipeName = newRecipes[5].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeSevenButton(_ sender: Any) {
        selectedRecipeId = newRecipes[6].id!
        selectedRecipeName = newRecipes[6].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeEightButton(_ sender: Any) {
        selectedRecipeId = newRecipes[7].id!
        selectedRecipeName = newRecipes[7].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeNineButton(_ sender: Any) {
        selectedRecipeId = newRecipes[8].id!
        selectedRecipeName = newRecipes[8].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    @IBAction func recipeTenButton(_ sender: Any) {
        selectedRecipeId = newRecipes[9].id!
        selectedRecipeName = newRecipes[9].title!
        self.performSegue(withIdentifier: "recipePageSegue", sender: sender)
    }
    
    @IBOutlet weak var recipeOneImage: UIImageView!
    @IBOutlet weak var recipeTwoImage: UIImageView!
    @IBOutlet weak var recipeThreeImage: UIImageView!
    @IBOutlet weak var recipeFourImage: UIImageView!
    @IBOutlet weak var recipeFiveImage: UIImageView!
    @IBOutlet weak var recipeSixImage: UIImageView!
    @IBOutlet weak var recipeSevenImage: UIImageView!
    @IBOutlet weak var recipeEightImage: UIImageView!
    @IBOutlet weak var recipeNineImage: UIImageView!
    @IBOutlet weak var recipeTenImage: UIImageView!
    
    @IBOutlet weak var recipeOneName: UILabel!
    @IBOutlet weak var recipeTwoName: UILabel!
    @IBOutlet weak var recipeThreeName: UILabel!
    @IBOutlet weak var recipeFourName: UILabel!
    @IBOutlet weak var recipeFiveName: UILabel!
    @IBOutlet weak var recipeSixName: UILabel!
    @IBOutlet weak var recipeSevenName: UILabel!
    @IBOutlet weak var recipeEightName: UILabel!
    @IBOutlet weak var recipeNineName: UILabel!
    @IBOutlet weak var recipeTenName: UILabel!
    
    @IBOutlet weak var recipeOneTime: UILabel!
    @IBOutlet weak var recipeTwoTime: UILabel!
    @IBOutlet weak var recipeThreeTime: UILabel!
    @IBOutlet weak var recipeFourTime: UILabel!
    @IBOutlet weak var recipeFiveTime: UILabel!
    @IBOutlet weak var recipeSixTime: UILabel!
    @IBOutlet weak var recipeSevenTime: UILabel!
    @IBOutlet weak var recipeEightTime: UILabel!
    @IBOutlet weak var recipeNineTime: UILabel!
    @IBOutlet weak var recipeTenTime: UILabel!
    
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    
    var recipeImages = [UIImageView]()
    var recipeNames = [UILabel]()
    var recipeTimes = [UILabel]()
    
    var selectedRecipeId: Int?
    var selectedRecipeName: String?
    
    let URL_REQUEST_STRING = "https://api.spoonacular.com/recipes/random?apiKey=&number=10"
    
    var newRecipes = [RecipeData]()
    
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
        var searchBarFrame = searchBar.frame
        searchBarFrame.size.width = self.SearchBarContainer.frame.size.width
        searchBar.frame = searchBarFrame
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
        
        recipeImages.append(recipeOneImage)
        recipeImages.append(recipeTwoImage)
        recipeImages.append(recipeThreeImage)
        recipeImages.append(recipeFourImage)
        recipeImages.append(recipeFiveImage)
        recipeImages.append(recipeSixImage)
        recipeImages.append(recipeSevenImage)
        recipeImages.append(recipeEightImage)
        recipeImages.append(recipeNineImage)
        recipeImages.append(recipeTenImage)
        recipeNames.append(recipeOneName)
        recipeNames.append(recipeTwoName)
        recipeNames.append(recipeThreeName)
        recipeNames.append(recipeFourName)
        recipeNames.append(recipeFiveName)
        recipeNames.append(recipeSixName)
        recipeNames.append(recipeSevenName)
        recipeNames.append(recipeEightName)
        recipeNames.append(recipeNineName)
        recipeNames.append(recipeTenName)
        recipeTimes.append(recipeOneTime)
        recipeTimes.append(recipeTwoTime)
        recipeTimes.append(recipeThreeTime)
        recipeTimes.append(recipeFourTime)
        recipeTimes.append(recipeFiveTime)
        recipeTimes.append(recipeSixTime)
        recipeTimes.append(recipeSevenTime)
        recipeTimes.append(recipeEightTime)
        recipeTimes.append(recipeNineTime)
        recipeTimes.append(recipeTenTime)
        
        //Populate page
        indicator.startAnimating()
        ScrollView.isHidden = true
        getRecipes()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        //Go to search view when search bar tapped
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewControllerOne") as! SearchViewControllerOne
        self.navigationController?.pushViewController(vc, animated: false)
        searchBar.endEditing(true)
    }
    
    //Searching api for meals
    func getRecipes(){
        guard let requestURL = URL(string: URL_REQUEST_STRING) else {
            print("Invalid URL.")
            return
        }
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            DispatchQueue.main.async {
                
            }
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let rootData = try decoder.decode(RandomRootData.self, from: data!)
                if let recipes = rootData.recipes {
                    for recipe in recipes {
                        self.newRecipes.append(recipe)
                    }
                    DispatchQueue.main.async {
                        self.populatePage()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    //Populate page with data from random recipe api call
    func populatePage(){
        for i in 0..<10{
            do {
                let recipe = newRecipes[i]
                let recipeImageUrl = "https://spoonacular.com/recipeImages/\(recipe.id!)-312x150.jpg"
                let url = URL(string: recipeImageUrl)
                let recipeData = try Data(contentsOf: url!)
                
                let currentImage = recipeImages[i]
                currentImage.image = UIImage(data: recipeData)
                currentImage.contentMode = .scaleAspectFill
                
                let currentName = recipeNames[i]
                currentName.text = newRecipes[i].title
                
                let currentTime = recipeTimes[i]
                currentTime.text = "\(String(newRecipes[i].readyInMinutes!)) MINS"
                
            }
            catch{
                print(error)
            }
        }
        self.indicator.stopAnimating()
        self.ScrollView.isHidden = false
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipePageSegue" {
            let destination = segue.destination as! RecipeViewController
            destination.selectedRecipeName = selectedRecipeName
            destination.selectedRecipeId = selectedRecipeId
        }
    }
}
