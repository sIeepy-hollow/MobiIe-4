//
//  BooksDetails.swift
//  LABKA4
//
//  Created by Aplyn on 23.05.2021.
//

import Foundation
import UIKit

class BooksDetails: UIViewController {
    
    var data: Book?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = ContentStore().getImage(data!.image as NSString)
        titleLabel.text = "Title: " + data!.title
        subtitleLabel.text = "Subtitle: " + data!.subtitle
        descriptionLabel.text = "Description: " + data!.desc!
        authorsLabel.text = "Authors: " + data!.authors!
        publisherLabel.text = "Publisher: " + data!.publisher!
        pagesLabel.text = "Pages: " + data!.pages!
        yearLabel.text = "Year: " + data!.year!
        ratingLabel.text = "Rating: " + data!.rating! + "/5"
    }
}
