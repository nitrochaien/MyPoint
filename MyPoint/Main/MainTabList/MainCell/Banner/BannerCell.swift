//
//  BannerCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    var frameSize: CGSize!
    var onSelect: ((_ banner: Banner) -> Void)?

    private let bannerDisplayTime: TimeInterval = 5.0

    var listBanners = [Banner]()
    var timer = Timer()
    var counter = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer),
                                               name: NotificationName.didLeaveMainScreen,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit BannerCell")
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: bannerDisplayTime,
                                     target: self,
                                     selector: #selector(changeImage),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
    }

    @objc func stopTimer() {
        timer.invalidate()
    }

    func setupBannerCollectionView(frameSize: CGSize) {
        if listBanners.count > 0 {
            bannerCollectionView.delegate = self
            bannerCollectionView.dataSource = self
            self.frameSize = frameSize
            pageControl.numberOfPages = listBanners.count
            pageControl.currentPage = 0
            bannerCollectionView.register(UINib(nibName: "BannerItemCell", bundle: nil), forCellWithReuseIdentifier: "BannerItemCell")
            bannerCollectionView.reloadData { [weak self] in
                self?.bannerCollectionView.layoutIfNeeded()
                self?.startTimer()
            }
        }
    }

    @objc func changeImage() {
        if listBanners.isEmpty { return }

        if counter < listBanners.count {
            DispatchQueue.main.async {
                let index = IndexPath(item: self.counter, section: 0)
                self.bannerCollectionView.scrollToItem(at: index,
                                                       at: .centeredHorizontally,
                                                       animated: true)
                self.counter += 1
            }
        } else {
            DispatchQueue.main.async {
                self.counter = 0
                let index = IndexPath(item: self.counter, section: 0)
                self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = 0
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let transition = scrollView.contentSize.width - scrollView.frame.size.width + 44
        if scrollView.contentOffset.x > transition {
            pageControl.currentPage = 0
            let index = IndexPath.init(item: 0, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        } else {
            pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        counter = pageControl.currentPage

        if !timer.isValid {
            startTimer()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return listBanners.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frameSize.width, height: frameSize.height - 60)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerItemCell", for: indexPath) as? BannerItemCell
            else {
                fatalError("Empty Cell")
        }
        if let url = URL(string: self.listBanners[safe: indexPath.row]?.itemImage ?? "") {
            cell.bannerImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
        } else {
            cell.bannerImageView.image = UIImage(named: "alter")
        }
        cell.bannerBackgroundView.cornerRadius = 8.0
        contentView.cornerRadius = 8.0
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        cell.layoutIfNeeded()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect?(listBanners[indexPath.row])
    }
}
