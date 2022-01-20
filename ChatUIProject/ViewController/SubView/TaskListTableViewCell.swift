//
//  TaskListTableViewCell.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/06.
//
// MARK: - Orbit - Task Card / Standard

import UIKit
import FlexLayout
import PinLayout

class TaskListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "TaskListTableViewCell"
    var task: Task? {
        didSet {
            guard let task = task else {
                return
            }
        }
    }
    
    // MARK: namespaces
    
    fileprivate enum Size {
        static let cornerRadius: CGFloat = 4
        static let borderWidth: CGFloat = 1
        static let colorLabelWidth: CGFloat = 3
        static let padding: CGFloat = 16
        static let margin: CGFloat = 8
        static let icon: CGSize = CGSize(width: 18, height: 18)
    }
    
    // MARK: UI Objects
    
    // flex containers
    var dateContainer =  UIView()
    
    // flex items
    var colorLabelView: UIView = UIView()
    var bgView: UIView = UIView()
    
    var statusImageView: UIImageView = UIImageView()
    var statusLabel: UILabel = UILabel()
    
    var priorityImageView: UIImageView = UIImageView()
    var taskTitleLabel: UILabel = UILabel()
    
    var profileImageView: UIImageView = UIImageView()
    var dateLabel: UILabel = UILabel()
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        colorLabelView.backgroundColor = .white
        profileImageView.image = UIImage(named: "User1")
        dateLabel.flex.display(.flex)
        dateContainer.flex.isIncludedInLayout(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    // MARK: - Functions
    
    // MARK: Init Layout
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: .default,
                   reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        configureUI()
        
        contentView.flex.addItem()
            .paddingVertical(Size.padding / 2)
            .define { flex in
                
                flex.addItem(colorLabelView)
                    .paddingLeft(Size.colorLabelWidth)
                    .define { flex in
                        
                        flex.addItem(bgView)
                            .padding(Size.padding)
                            .direction(.column)
                            .define { flex in
                                
                                // status
                                flex.addItem().direction(.row).define { flex in
                                    flex.addItem(statusImageView)
                                        .size(Size.icon)
                                        .marginRight(Size.padding)
                                    flex.addItem(statusLabel)
                                }
                                
                                // title
                                flex.addItem().direction(.row).define { flex in
                                    flex.addItem(priorityImageView)
                                        .size(Size.icon)
                                        .marginRight(Size.padding)
                                    flex.addItem(taskTitleLabel)
                                        .shrink(1)
                                        .grow(1)
                                }
                                .marginTop(Size.padding)
                                
                                // date
                                flex.addItem(dateContainer).direction(.row).define { flex in
                                    flex.addItem(profileImageView)
                                        .size(Size.icon)
                                        .marginRight(Size.padding)
                                    flex.addItem(dateLabel)
                                        .shrink(1)
                                }
                                .marginTop(Size.padding)
                            }
                    }
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configure UI
    private func configureUI() {
        colorLabelView.makeRoundedWithBorder(radius: Size.cornerRadius,
                                             color: UIColor(named: "BorderColor")!.cgColor)
        bgView.backgroundColor = .white
        bgView.makeRounded(radius: Size.cornerRadius)
        
        statusLabel.textColor = .gray
        statusLabel.font = statusLabel.font.withSize(12)
        
        taskTitleLabel.numberOfLines = 0
        taskTitleLabel.font = taskTitleLabel.font.withSize(16)
        
        profileImageView.image = UIImage(named: "User1")
        profileImageView.makeRounded(radius: Size.icon.height / 2)
        dateLabel.numberOfLines = 0
        dateLabel.font = dateLabel.font.withSize(12)
    }
    
    func setCell(task: Task?) {
        
        guard let task: Task = task else { return }
        
        if task.logColor != "" {
            colorLabelView.backgroundColor = UIColor(hex: task.logColor)
        }
        
        statusImageView.image = Icons.Status(rawValue: task.logStatus)?.image ?? Icons.errIcon
        statusLabel.text = task.logStatus
        statusLabel.flex.markDirty()
        
        priorityImageView.image = Icons.Priority(rawValue: task.priority)?.image ?? Icons.errIcon
        taskTitleLabel.text = task.logTitle
        taskTitleLabel.flex.markDirty()
        
        dateLabel.text = "\(task.logSdt) ~ \(task.logEdt)"
        dateLabel.flex.markDirty()
        
        if task.memberList[0] == "unassign" {
            profileImageView.image = UIImage()
        }
        
        if task.logSdt == "" && task.logEdt == "" {
            dateLabel.flex.display(.none)
        }
        
        if task.memberList[0] == "unassign" && task.logSdt == "" && task.logEdt == "" {
            dateContainer.flex.isIncludedInLayout(false)
            dateContainer.flex.markDirty()
        }
        
        self.contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    
    //
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

