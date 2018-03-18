//
//  WeatherListTableViewCell.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell, WeatherListCellView {
    
    //MARK: - Properties
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var detailsButton: UIButton!
    
    @IBOutlet private weak var movingCentralConstraint: NSLayoutConstraint!
    
    private var panGesture: UIPanGestureRecognizer!
    
    var presenter: WeatherListCellPresenter!
    
    var velocityInView: CGPoint {
        return panGesture.velocity(in: contentView)
    }
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        presenter = WeatherListCellPresenterImplementation(view: self)
    }
    
    //MARK: - IBActions
    
    @IBAction private func detailsButtonTapped(_ sender: Any) {
        presenter.detailsButtonTapped()
    }
    
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        presenter.deletButtonTapped()
    }
    
    @IBAction private func swipeGestureAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let point = sender.translation(in: contentView)
            presenter.prepareDeleteButtonForChangedStateWith(point: point)
        case .cancelled, .ended:
            presenter.prepareDeleteButtonForFinishedState()
        default:
            break
        }
    }
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func set(temperature: String, andDate date: String) {
        temperatureLabel.text = temperature
        dateLabel.text = date
    }

    func set(detailsButtonText: String) {
        detailsButton.setTitle(detailsButtonText, for: .normal)
    }
    
    func prepareGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeGestureAction(_:)))
        panGesture!.delegate = self
        contentView.addGestureRecognizer(panGesture!)
    }
    
    func setDeleteButtonConstraintWith(value: CGFloat) {
        movingCentralConstraint.constant = value
    }
    
    func reloadViewAnimated() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentView.layoutIfNeeded()
        }
    }
    
    func setGesture(enabled: Bool) {
        panGesture.isEnabled = enabled
    }
}

//MARK: - UIGestureRecognizerDelegate

extension WeatherListTableViewCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return presenter.swipeGesureShouldBegin
    }
}
