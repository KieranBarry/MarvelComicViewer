//
//  TestVC.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/16/21.
//


import UIKit


/// View Controller for comic Detail view
class ComicDetailViewController: UIViewController {

    // MARK: Properties
    private var blurView: UIVisualEffectView?
    
    var comic: Comic?
    
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
    
    // View containing all comic text-based view
    @IBOutlet private weak var comicTextContainerView: UIView!

    // Text views of main layout
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var issueNumberLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    
    // portrait description
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    // landscape description
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    // Image view of main layout
    @IBOutlet private weak var comicImageView: UIImageView!
    
    // Network loading indicator
    @IBOutlet private weak var activitySpinner: UIActivityIndicatorView!
    
    // Error view
    @IBOutlet private weak var networkErrorLabel: UILabel!
    
    
    
    // MARK: Actions
    
    /**
     Action for Read More button that toggle's text and the number of lines for descriptionLabel to display
     - parameter sender: the UIButton that sent the action
     */
    @IBAction private func toggleReadMore(_ sender: UIButton) {
        if sender.currentTitle == "Read More" {
            sender.setTitle("Read Less", for: .normal)
        } else {
            sender.setTitle("Read More", for: .normal)
        }
        
        descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == Constants.numberOfDescriptionLinesToDisplay ? 0 : Constants.numberOfDescriptionLinesToDisplay
        
        UIView.animate(withDuration: 0.5) { [ weak self ] in
            self?.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAccessabilityIdentifiers()
        
        updateComicUI()
        fetchImage()
        
        networkErrorLabel.isHidden = true
//        comicImageView.isHidden = true
        
        // Remove padding from text view
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // only display blur view when in portrait mode
        blurView?.isHidden = size.height > size.width ? false : true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: Network Requests
    
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
                        self?.addBlurView()
                        self?.activitySpinner.stopAnimating()
                    case .failure(_):
                        self?.hideImageView()
                    }
                }
            }
        }
    }
    
    
    
    // MARK: UI Methods
    
    /// Update's text views to display data stored in comic
    private func updateComicUI() {
        if let comic = comic {
            issueNumberLabel.text = "Issue: \(comic.issueNumber)"
            authorsLabel.text = comic.authors.count > 0 ? "By: \(comic.authors.asOxfordCommaList())" : ""
            titleLabel.text = comic.title.uppercased()

            if let description = comic.description {
                descriptionLabel.text = description
                descriptionTextView.text = description
                
                if !descriptionLabel.isTruncated {
                    readMoreButton.removeFromSuperview()
                }
            } else {
                // there is no description
                descriptionTextView.removeFromSuperview()
                descriptionLabel.removeFromSuperview()
                readMoreButton.removeFromSuperview()
            }
        }
    }
    
    /// Removes comic image view from layout
    private func hideImageView() {
        comicImageView.removeFromSuperview()
    }
    
    /// Unhides blurView. If not yet created, programatically adds blur overlay effect to comicTextContainerView
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        if let blurView = blurView {
            blurView.alpha = 0.7
            blurView.translatesAutoresizingMaskIntoConstraints = false
            comicTextContainerView.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([
              blurView.topAnchor.constraint(equalTo: comicTextContainerView.topAnchor),
              blurView.leadingAnchor.constraint(equalTo: comicTextContainerView.leadingAnchor),
              blurView.heightAnchor.constraint(equalTo: comicTextContainerView.heightAnchor),
              blurView.widthAnchor.constraint(equalTo: comicTextContainerView.widthAnchor)
            ])
        }
        
        // hide blurView if in landscape
        if self.traitCollection.verticalSizeClass == .compact {
            blurView?.isHidden = true
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
    
    
    
    // MARK: Accessility SetUp
    
    /// Sets accessibility labels for all content-holding views
    private func setUpAccessabilityIdentifiers() {
        titleLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicTitle.rawValue
        issueNumberLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicIssueNumber.rawValue
        authorsLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicAuthors.rawValue
        descriptionLabel.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicDescription.rawValue
        descriptionTextView.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicDescription.rawValue
        comicImageView.accessibilityIdentifier = Constants.AccessibilityIdentifiers.comicImage.rawValue
    }
}

