//
//  PhotoViewerViewController.swift
//  UnsplashCloneApp
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class PhotoViewerViewController: BaseViewController {

    private let viewModel: PhotoViewerViewModel
    private let rootView = PhotoViewerView()

    private var didSetupImageFrame = false

    init(viewModel: PhotoViewerViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    convenience init(image: UIImage) {
        self.init(
            viewModel: PhotoViewerViewModel(image: image)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !self.didSetupImageFrame else { return }
        self.didSetupImageFrame = true

        self.configureInitialImageFrame()
    }
}

// MARK: - Setup

private extension PhotoViewerViewController {
    func setupView() {
        self.rootView.imageView.image = self.viewModel.image
        self.rootView.scrollView.delegate = self
        self.rootView.scrollView.minimumZoomScale = self.viewModel.minimumZoomScale
        self.rootView.scrollView.maximumZoomScale = self.viewModel.maximumZoomScale
    }

    func bindGesture() {
        let singleTap = rootView.rx.tapGesture { gesture, _ in
            gesture.numberOfTapsRequired = 1
        }
        .share()

        let doubleTap = rootView.rx.tapGesture { gesture, _ in
            gesture.numberOfTapsRequired = 2
        }
        .share()

        singleTap
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        doubleTap
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { owner, gesture in
                owner.handleDoubleTap(gesture)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

private extension PhotoViewerViewController {
    func configureInitialImageFrame() {
        let scrollSize = self.rootView.scrollView.bounds.size
        let imageSize = self.viewModel.image.size

        guard scrollSize != .zero, imageSize != .zero else { return }

        let scale = min(
            scrollSize.width / imageSize.width,
            scrollSize.height / imageSize.height
        )

        let fittedSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )

        self.rootView.imageView.frame = CGRect(
            origin: .zero,
            size: fittedSize
        )

        self.rootView.scrollView.contentSize = fittedSize
        self.centerImage()
    }

    func centerImage() {
        let scrollSize = self.rootView.scrollView.bounds.size
        let contentSize = self.rootView.scrollView.contentSize

        let insetX = max((scrollSize.width - contentSize.width) / 2, 0)
        let insetY = max((scrollSize.height - contentSize.height) / 2, 0)

        self.rootView.scrollView.contentInset = UIEdgeInsets(
            top: insetY,
            left: insetX,
            bottom: insetY,
            right: insetX
        )
    }

    func zoomRect(
        for scale: CGFloat,
        center: CGPoint
    ) -> CGRect {
        let scrollView = self.rootView.scrollView

        let size = CGSize(
            width: scrollView.bounds.width / scale,
            height: scrollView.bounds.height / scale
        )

        return CGRect(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
}

// MARK: - Actions

private extension PhotoViewerViewController {
    func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let scrollView = self.rootView.scrollView

        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(
                scrollView.minimumZoomScale,
                animated: true
            )
            return
        }

        let point = gesture.location(in: self.rootView.imageView)

        let targetScale = min(
            scrollView.maximumZoomScale,
            scrollView.zoomScale * self.viewModel.doubleTapZoomScale
        )

        let rect = self.zoomRect(
            for: targetScale,
            center: point
        )

        scrollView.zoom(
            to: rect,
            animated: true
        )
    }
}

// MARK: - UIScrollViewDelegate

extension PhotoViewerViewController: UIScrollViewDelegate {
    func viewForZooming(
        in scrollView: UIScrollView
    ) -> UIView? {
        return self.rootView.imageView
    }

    func scrollViewDidZoom(
        _ scrollView: UIScrollView
    ) {
        self.centerImage()
    }
}
