//
//  CategoryCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryHeaderLabel: UILabel!
    var frameSize: CGSize!
    var listCategory = [Category]()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.translatesAutoresizingMaskIntoConstraints = false
        categoryHeaderLabel.text = "category.category".localized
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
  
    func setupCategoryCollectionView(frameSize: CGSize) {
      categoryCollectionView.delegate = self
      categoryCollectionView.dataSource = self
      categoryCollectionView.reloadData()
      self.frameSize = frameSize
      pageControl.numberOfPages = 2
      pageControl.currentPageIndicatorTintColor = .red
      pageControl.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
      categoryCollectionView.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "CategoryItemCell")
      if listCategory.count % 8 != 0 {
        var index = listCategory.count % 8
        repeat {
          let blankCategory = Category(id: "-1", subscribed: "0", categoryCode: "", categoryName: "", imageUrl: "blank")
          self.listCategory.append(blankCategory)
          index += 1
        } while index <= listCategory.count % 8
      }
    }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.x > (scrollView.contentSize.width - scrollView.frame.size.width) {
      pageControl.currentPage = 0
      let index = IndexPath.init(item: 0, section: 0)
      self.categoryCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
  }
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return listCategory.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (frameSize.width / 4), height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as? CategoryItemCell
        else {
        fatalError("Empty Cell")
      }
      cell.categoryTitleLabel.text = listCategory[safe: indexPath.row]?.categoryName ?? ""
      if let urlString = listCategory[safe: indexPath.row]?.imageURL, urlString == "blank"{
        print(urlString)
        cell.categoryImageView.image = nil
      } else {
        if let url = URL(string: listCategory[safe: indexPath.row]?.imageURL ?? "") {
          cell.categoryImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
        } else {
          cell.categoryImageView.image = UIImage(named: "alter")
        }
      }
      return cell
    }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("tapppppp \(indexPath.row)")
    let storyboard = UIStoryboard(name: "Category", bundle: nil)
    let tab = CategoryTabViewController()
    var categoryTabs = [CategoryTab]()
    for category in listCategory {
        let vc = storyboard
            .instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        vc.category = category
        categoryTabs.append(CategoryTab(title: category.categoryName ?? "",
                                        viewController: vc))
    }
    tab.title = "category.category".localized
    tab.setTitles(categoryTabs: categoryTabs, distribution: .normal)
    tab.firstSelectedIndex = indexPath.row
    let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
    tabbarViewController?.navigationBar.isHidden = false
    tabbarViewController?.pushViewController(tab, animated: true)
  }

}
