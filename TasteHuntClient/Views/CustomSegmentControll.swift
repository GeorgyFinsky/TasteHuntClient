//
//  CustomSegmentControll.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import SnapKit
import UIKit

class UniversalSegmenControl: UIView {
    
    private lazy var mainContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = selectionViewBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    public var selectionViewBackgroundColor: UIColor = .white.withAlphaComponent(0.5) {
        willSet {
            selectionView.backgroundColor = newValue
        }
    }
    
    public var activeLabelTextColor: UIColor = .purple {
        didSet {
            self.setActiveState()
        }
    }
    
    public var inactiveLabelTextColor: UIColor = .white {
        didSet {
            self.setInactiveState()
        }
    }
    
    private weak var delegate: SegmentDelegate?
    private var segmentItems: [Segmentable]
    private var selectedElement: Segmentable? {
        didSet {
            self.selectedIndex = selectedElement?.index ?? 0
        }
    }
    
    private(set) var selectedIndex: Int = 0
    
    init(
        elements: [Segmentable],
        delegate: SegmentDelegate?
    ) {
        guard let delegate, !elements.isEmpty else {
            fatalError("You forget implement SegmentDelegate or elements is empty")
        }
        
        self.delegate = delegate
        self.segmentItems = elements
        self.selectedElement = elements.first
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeConstraints()
        self.setInactiveState()
        self.setActiveState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(mainContentView)
        mainContentView.addSubview(selectionView)
    }
    
    private func makeConstraints() {
        guard let selectedElement else { return }
        
        mainContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let itemWidth = mainContentView.frame.width / CGFloat(segmentItems.count)
        let selectionPosition = itemWidth * CGFloat(selectedElement.index)
        
        selectionView.snp.remakeConstraints { make in
            make.width.equalTo(itemWidth)
            make.bottom.height.equalToSuperview()
            make.leading.equalToSuperview().offset(selectionPosition)
        }
        
        segmentItems.enumerated().forEach { index, item in
            let label = createElement(for: item)
            self.mainContentView.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(itemWidth)
                make.leading.equalTo(itemWidth * CGFloat(index))
            }
            
        }
    }
    
    private func createElement(for item: Segmentable) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = item.title
        label.tag = item.index
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(elementTapped(sender:))
        )
        label.addGestureRecognizer(tap)
        return label
    }
    
    @objc private func elementTapped(sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        self.selectedElement = segmentItems[index]
        moveSelectionLine()
        delegate?.segmentDidChange(index: index)
    }
    
    private func moveSelectionLine() {
        guard let selectedElement else { return }
        
        let itemWidth = mainContentView.frame.width / CGFloat(segmentItems.count)
        
        selectionView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(
                itemWidth * CGFloat(selectedElement.index)
            )
        }
        self.setInactiveState()
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            
            self.layoutIfNeeded()
        } completion: { [weak self] isFinish in
            guard let self, isFinish else { return }
            self.setActiveState()
            
        }
    }
    
    private func setActiveState() {
        guard let selectedElement else { return }
        let labels = mainContentView.subviews
            .filter({$0 is UILabel})
            .compactMap({$0 as? UILabel})
        
        labels.forEach { label in
            if label.tag == selectedElement.index {
                label.font = UIFont.boldSystemFont(ofSize: 17)
                label.textColor = self.activeLabelTextColor
            }
        }
    }
    
    private func setInactiveState() {
        let labels = mainContentView.subviews.filter({$0 is UILabel}).compactMap({$0 as? UILabel})
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = self.inactiveLabelTextColor
        }
    }
    
}
