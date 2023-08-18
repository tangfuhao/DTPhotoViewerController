//
//  CSSimpleImageViewerViewController.swift
//  Pods
//
//  Created by fuhao on 2023/8/18.
//


import UIKit
//
//private var kElementHorizontalMargin: CGFloat { return 20 }
//private var kElementHeight: CGFloat { return 40 }
//private var kElementWidth: CGFloat { return 50 }
//private var kElementBottomMargin: CGFloat { return 10 }

protocol SimplePhotoViewerControllerDelegate: DTPhotoViewerControllerDelegate {
    func simplePhotoViewerController(_ viewController: CSSimpleImageViewerViewController, savePhotoAt index: Int)
}

class CustomPhotoCollectionViewCell: DTPhotoCollectionViewCell {
//    lazy var extraLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .right
//        label.textColor = UIColor.white
//        label.font = UIFont.systemFont(ofSize: 15)
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        addSubview(extraLabel)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let insets: UIEdgeInsets
//
//        if #available(iOS 11.0, *) {
//            insets = safeAreaInsets
//        } else {
//            insets = UIEdgeInsets.zero
//        }
//
//        let width: CGFloat = 200
//        extraLabel.frame = CGRect(x: bounds.size.width - width - 20 - insets.right, y: insets.top, width: width, height: 30)
//    }
}


class CSSimpleImageWeak {
    weak var value: UIImageView?
    
    init(_ value: UIImageView) {
        self.value = value
    }
}


// MARK: DTPhotoViewerControllerDataSource
extension CSSimpleImageViewerViewController: DTPhotoViewerControllerDataSource {
    public func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {}

    public func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        return imageViewWeakArray[index].value
    }

    public func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return imageViewWeakArray.count
    }

    public func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        print("photoViewerController index: \(index)")
        guard let mImageview = imageViewWeakArray[index].value else {return}
        imageView.image = mImageview.image
    }
}

// MARK: DTPhotoViewerControllerDelegate
extension CSSimpleImageViewerViewController: SimplePhotoViewerControllerDelegate {
    public func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }

    public func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
    }

    func simplePhotoViewerController(_ viewController: CSSimpleImageViewerViewController, savePhotoAt index: Int) {
        guard let mImageview = imageViewWeakArray[index].value else {return}
        guard let image = mImageview.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

public class CSSimpleImageViewerViewController: DTPhotoViewerController {
//    lazy var cancelButton: UIButton = {
//        let cancelButton = UIButton(frame: CGRect.zero)
//        cancelButton.setImage(UIImage.cancelIcon(size: CGSize(width: 15, height: 15), color: UIColor.white), for: UIControl.State())
//        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: UIControl.Event.touchUpInside)
//        cancelButton.contentHorizontalAlignment = .left
//        cancelButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        return cancelButton
//    }()
//
//    lazy var moreButton: UIButton = {
//        let moreButton = UIButton(frame: CGRect.zero)
//        moreButton.setImage(UIImage.moreIcon(size: CGSize(width: 16, height: 16), color: UIColor.white), for: UIControl.State())
//        moreButton.contentHorizontalAlignment = .right
//        moreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kElementHorizontalMargin)
//        moreButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: UIControl.Event.touchUpInside)
//        return moreButton
//    }()
    
    var imageViewWeakArray: [CSSimpleImageWeak] = []
    var selectedImageIndex: Int
    

    deinit {
        print("SimplePhotoViewerController deinit")
    }
    
    public init(imageViewArray: [UIImageView], selectedImageIndex: Int) {
        self.imageViewWeakArray = imageViewArray.map{ CSSimpleImageWeak($0)}
        self.selectedImageIndex = selectedImageIndex
        
        let selectedView = imageViewArray[selectedImageIndex]
        super.init(referencedView: selectedView, image: selectedView.image)
        
        delegate = self
        dataSource = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        registerClassPhotoViewer(CustomPhotoCollectionViewCell.self)
//        view.addSubview(cancelButton)
//        view.addSubview(moreButton)

//        configureOverlayViews(hidden: true, animated: false)
        // Do any additional setup after loading the view.
    }

//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let y = bottomButtonsVerticalPosition()
//
//        let insets: UIEdgeInsets
//
//        if #available(iOS 11.0, *) {
//            insets = view.safeAreaInsets
//        } else {
//            insets = UIEdgeInsets.zero
//        }
//
//        // Layout subviews
//        let buttonHeight: CGFloat = kElementHeight
//        let buttonWidth: CGFloat = kElementWidth
//
//        cancelButton.frame = CGRect(origin: CGPoint(x: 20 + insets.left, y: insets.top), size: CGSize(width: buttonWidth, height: buttonHeight))
//        moreButton.frame = CGRect(origin: CGPoint(x: view.bounds.width - buttonWidth - insets.right, y: y - insets.bottom), size: CGSize(width: buttonWidth, height: kElementHeight))
//    }

//    @IBAction private func moreButtonTapped(_ sender: UIButton) {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//        let saveButton = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { _ in
//            // Save photo to Camera roll
//            if let delegate = self.delegate as? SimplePhotoViewerControllerDelegate {
//                delegate.simplePhotoViewerController(self, savePhotoAt: self.currentPhotoIndex)
//            }
//        }
//        alertController.addAction(saveButton)
//        present(alertController, animated: true, completion: nil)
//    }

//    @objc
//    func cancelButtonTapped(_ sender: UIButton) {
//        hideInfoOverlayView(false)
//        dismiss(animated: true, completion: nil)
//    }

//    func hideInfoOverlayView(_ animated: Bool) {
//        configureOverlayViews(hidden: true, animated: animated)
//    }
//
//    func showInfoOverlayView(_ animated: Bool) {
//        configureOverlayViews(hidden: false, animated: animated)
//    }

//    func configureOverlayViews(hidden: Bool, animated: Bool) {
//        if hidden != cancelButton.isHidden {
//            let duration: TimeInterval = animated ? 0.2 : 0.0
//            let alpha: CGFloat = hidden ? 0.0 : 1.0
//
//            // Always unhide view before animation
//            setOverlayElementsHidden(isHidden: false)
//
//            UIView.animate(withDuration: duration, animations: {
//                self.setOverlayElementsAlpha(alpha: alpha)
//            }, completion: { _ in
//                self.setOverlayElementsHidden(isHidden: hidden)
//                }
//            )
//        }
//    }
//
//    func setOverlayElementsHidden(isHidden: Bool) {
//        cancelButton.isHidden = isHidden
//        moreButton.isHidden = isHidden
//    }
//
//    func setOverlayElementsAlpha(alpha: CGFloat) {
//        moreButton.alpha = alpha
//        cancelButton.alpha = alpha
//    }
//
//    override func didReceiveTapGesture() {
//        reverseInfoOverlayViewDisplayStatus()
//    }
//
//    private func bottomButtonsVerticalPosition() -> CGFloat {
//        return view.bounds.height - kElementHeight - kElementBottomMargin
//    }
//
//    @objc
//    override func willZoomOnPhoto(at index: Int) {
//        hideInfoOverlayView(false)
//    }
//
//    override func didEndZoomingOnPhoto(at index: Int, atScale scale: CGFloat) {
//        if scale == 1 {
//            showInfoOverlayView(true)
//        }
//    }
//
//    override func didEndPresentingAnimation() {
//        showInfoOverlayView(true)
//    }
//
//    override func willBegin(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
//        hideInfoOverlayView(false)
//    }
//
//    override func didReceiveDoubleTapGesture() {
//        hideInfoOverlayView(false)
//    }
//
//    // Hide & Show info layer view
//    func reverseInfoOverlayViewDisplayStatus() {
//        if zoomScale == 1.0 {
//            if cancelButton.isHidden == true {
//                showInfoOverlayView(true)
//            } else {
//                hideInfoOverlayView(true)
//            }
//        }
//    }

}
