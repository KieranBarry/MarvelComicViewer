//
//  ViewController.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import UIKit


/// View Controller for comic Detail view
class ComicDetailViewController: UIViewController {

    // MARK: Properties
        
    private var comic: Comic? {
        // Updates UI anytime comic is set to new value
        didSet {
            comicContainerView.isHidden = false
            updateComicUI()
        }
    }
    
    private var comicImage: UIImage? {
        get {
            comicImageView.image
        }
        set {
            comicImageView.image = newValue
        }
    }
    
    
    
    // MARK: Outlets
    
    // Container view of main layout
    @IBOutlet private weak var comicContainerView: UIView!
    
    // Text views of main layout
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var issueNumberLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    @IBOutlet private weak var descriptionHeaderLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    // Image view of main layout
    @IBOutlet private weak var comicImageView: UIImageView!
    
    // Network loading indicator
    @IBOutlet private weak var activitySpinner: UIActivityIndicatorView!
    
    // Error view
    @IBOutlet private weak var networkErrorLabel: UILabel!
    
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAccessabilityIdentifiers()
        
        fetchComic()
        
        networkErrorLabel.isHidden = true
        comicContainerView.isHidden = true
        descriptionHeaderLabel.isHidden = true
        descriptionTextView.isHidden = true
        
        // Remove padding from text view
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    
    
    // MARK: Network Requests
    
    /**
     Launces fetch request for comic data with Constants.comicId from Marvel API and updates UI based on result.
     On success, launches image fetch request. On failure, displays network error views.
     */
    private func fetchComic() {
        MarvelAPIManager.shared.fetchComic(matching: Constants.comicId) { result in
            DispatchQueue.main.async { [ weak self ] in
                switch result {
                
                case .success(let comic):
                    self?.comic = comic
                    self?.fetchImage()
                
                case .failure(let error):
                    self?.displayNetworkError(error)
                }
                
                self?.activitySpinner.stopAnimating()
            }
        }
    }
    
    /**
     Launches fetch request for comic's cover image and updates UI based on result.
     Removes comicImageView on failure or if there is no image associated with comic.
     */
    private func fetchImage() {
        if let comic = comic {
            guard !comic.imagePath.path.hasSuffix("image_not_available") else {
                hideImageView()
                return
            }
            MarvelAPIManager.shared.fetchImage(from: comic.imagePath) { result in
                DispatchQueue.main.async { [ weak self ] in
                    switch result {
                    case .success(let image):
                        self?.comicImage = image
                    case .failure(_):
                        self?.hideImageView()
                    }
                }
            }
        }
    }
    
    
    
    // MARK: UI Methods
    
    /**
     Update's text views to display data stored in comic
     */
    private func updateComicUI() {
        if let comic = comic {
            issueNumberLabel.text = "Issue: \(comic.issueNumber)"
            authorsLabel.text = comic.authors.count > 0 ? "By: \(comic.authors.asOxfordCommaList())" : ""
            titleLabel.text = comic.title.uppercased()
            
            if let description = comic.description {
                descriptionHeaderLabel.isHidden = false
                descriptionTextView.isHidden = false
                descriptionTextView.text = description
            }
        }
    }
    
    /**
     Display's network error views with specified error message
     
     - Parameter error: the error message to display
     */
    private func displayNetworkError(_ error: APIError) {
        comicContainerView.isHidden = true
        networkErrorLabel.text = Constants.networkErrorText + "\n" + error.rawValue
        networkErrorLabel.sizeToFit()
        networkErrorLabel.isHidden = false
    }
    
    /**
     Removes the comic image view and adds autolayout constaints to adjust location of comic text views appropriately
     */
    private func hideImageView() {
        if let comicContainerView = comicContainerView {
            comicImageView.removeFromSuperview()
        
            let viewsToShift = [titleLabel, issueNumberLabel, authorsLabel, descriptionHeaderLabel, descriptionTextView]
        
            for view in viewsToShift {
                let constraint = NSLayoutConstraint(item: comicContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: -20.0)
                comicContainerView.addConstraint(constraint)
            }
        }
    }
    
    
    
    // MARK: Accessility SetUp
    
    
    /// Sets accessibility labels for all content-holding views
    private func setUpAccessabilityIdentifiers() {
        titleLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicTitle.rawValue
        issueNumberLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicIssueNumber.rawValue
        authorsLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicAuthors.rawValue
        descriptionHeaderLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicDescriptionHeader.rawValue
        descriptionTextView.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicDescription.rawValue
        comicImageView.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicImage.rawValue
    }
}
