//
//  UniversalTableViewCell.swift
//  ShareAndNav
//
//  Created by 徐成 on 15/10/28.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

enum UniversalCellStyle {
    case RightButton,RightLabel,RightSwitch,LeftILRightL,TextField//,RightObject
}
enum XuTextFieldInputType {
    case Date,CityAndArea
}

@objc protocol UniversalTableViewCellDelegate {
    optional func universalRightSwitchChanged(cell:UITableViewCell,boolValue:Bool)
}

class UniversalTableViewCell: UITableViewCell ,XuPickerViewDelegate{
    
    var delegate:UniversalTableViewCellDelegate?
    var rightSwitchChanged : ((Bool) -> Void)?
    var rightButtonClicked : (() -> Void)?
    private var leftImageView:UIImageView?
    private var leftLabel:UILabel?
    private var rightLabel:UILabel?
    private var rightSwitch:UISwitch?
    private var rightButton:UIButton?
    var textField:HoshiTextField?
    var rightObject:NSObject?
    var leftShift:CGFloat = 0 {
        didSet{
            guard leftLabel != nil else {return}
            leftLabel?.center.x += leftShift
        }
    }
    
    var leftImage:UIImage? {
        didSet{
            guard leftImageView != nil else {return}
            leftImageView?.frame = CGRectMake(0, 0, 30, 30 * leftImage!.size.height / leftImage!.size.width)
            leftImageView?.image = leftImage
            leftImageView?.center = CGPointMake(35, XuCellHeight / 2)
            guard leftLabel != nil else {return}
            leftLabel?.center.x += 40
        }
    }
    
    var leftLabelText:String? {
        didSet{
            guard leftLabel != nil else {return}
            let width = XuTextSizeMiddle * CGFloat(NSString(string: leftLabelText!).length)
            leftLabel?.frame.size = CGSizeMake(width + 10, XuTextSizeMiddle + 5)
            leftLabel?.text = leftLabelText
            leftLabel?.center = CGPointMake(25 + width / 2, XuCellHeight / 2)
        }
    }
    
    var rightShift:CGFloat? {
        didSet{
            
        }
    }
    
    var rSwitchState:Bool = false {
        didSet{
            guard rightSwitch != nil else {return}
            rightSwitch?.on = rSwitchState
            if self.accessoryType != UITableViewCellAccessoryType.DisclosureIndicator {
                rightSwitch?.center.x = XuWidth - 35
            }
        }
    }
    
    var rightLabelText:String? {
        didSet{
            guard rightLabel != nil && rightLabelText != nil else {return}
            let width = XuTextSizeMiddle * CGFloat(NSString(string: rightLabelText!).length)
            var size = CGSizeMake(width + 10, XuTextSizeMiddle + 5)
            var center = CGPointMake(XuWidth - width / 2 - 35,XuCellHeight / 2)
            if (width > XuWidth - 120) && (!rightLabelText!.containsString("/")) {
                size = rightLabelText!.sizeWithMaxSize(CGSizeMake(XuWidth - 120, XuWidth - 120), fontSize: XuTextSizeMiddle)
                center.y = size.height / 2 + 18
                center.x = XuWidth - size.width / 2 - 30
                rightLabel?.textAlignment = NSTextAlignment.Left
                rightLabel?.numberOfLines = 0
                self.frame.size.height = size.height + 36
            }
            rightLabel?.frame.size = size
            rightLabel?.text = rightLabelText
            rightLabel?.center = center
            if self.accessoryType != UITableViewCellAccessoryType.DisclosureIndicator {
                rightLabel?.center.x += 10
            }
        }
    }
    
    var rightButtonTitle:String? {
        didSet{
            guard rightButton != nil else {return}
            rightButton?.setTitle(rightButtonTitle, forState: UIControlState.Normal)
            let width = XuTextSizeMiddle * CGFloat(NSString(string: rightButtonTitle!).length) + 5
            rightButton?.frame.size = CGSizeMake(width + 10, XuTextSizeMiddle + 5)
            rightButton?.center = CGPointMake(XuWidth - width / 2 - 35, XuCellHeight / 2)
            if rightLabel != nil {
                rightLabel?.center.x -= width + 20
            }
            
            if self.accessoryType != UITableViewCellAccessoryType.DisclosureIndicator {
                rightButton?.center.x += 10
            }
        }
    }
    
    var textPlaceholder:String? {
        didSet{
            guard textField != nil else {return}
            textField?.placeholder = textPlaceholder
        }
    }
    
    var textFieldText:String? {
        didSet{
            guard textField != nil else {return}
            textField?.text = textFieldText
        }
    }
    
    var textInputType:XuTextFieldInputType? {
        didSet{
            guard textField != nil else {return}
            switch textInputType! {
            case .Date:
                let pickerView = XuPickerView(style: XuPickerStyle.Date)
                textField?.inputView = pickerView
                pickerView.delegate = self
            case .CityAndArea:
                let pickerView = XuPickerView(style: XuPickerStyle.CityAndArea)
                textField?.inputView = pickerView
                pickerView.delegate = self
            //default:break
            }
        }
    }
    
    init(universalStyle:UniversalCellStyle,reuseIdentifier:String) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        switch universalStyle {
        case .RightButton:
            self.initLeftLabel()
            self.initRightButton()
        case .RightSwitch:
            self.initLeftLabel()
            self.initRightSwitch()
        case .RightLabel:
            self.initLeftLabel()
            self.initRightLabel()
        case .LeftILRightL:
            self.initLeftLabel()
            self.initLeftImageView()
            self.initRightLabel()
        case .TextField:
            self.initRightTextField()
        //default:break
        }
    }
    
    init(rightObject:NSObject?,reuseIdentifier:String) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.initLeftLabel()
        switch rightObject {
        case nil:
            break
        case is UIView:
            self.rightObject = rightObject
            (rightObject as! UIView).center = CGPointMake(XuWidth - CGRectGetWidth((rightObject as! UIView).frame) / 2 - 30, XuCellHeight / 2)
            if self.accessoryType != UITableViewCellAccessoryType.DisclosureIndicator {
                (rightObject as! UIView).center.x += 10
            }
            self.contentView.addSubview(rightObject as! UIView)
        default:break
        }
    }
    
    //MARK: -- init
    func initLeftLabel() {
        leftLabel = UILabel(frame: CGRectMake(15, 0, 0, 20))
        leftLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        leftLabel?.center.y = XuCellHeight / 2
        self.contentView.addSubview(leftLabel!)
    }
    
    func initLeftImageView() {
        leftImageView = UIImageView()
        self.contentView.addSubview(leftImageView!)
    }
    
    func initRightButton() {
        rightButton = UIButton(type: UIButtonType.System)
        rightButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightButton?.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        rightButton?.backgroundColor = XuColorBlue
        rightButton?.frame = CGRectZero
        rightButton?.layer.cornerRadius = XuCornerRadius
        rightButton?.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(rightButton!)
    }
    
    func initRightSwitch() {
        rightSwitch = UISwitch(frame: CGRectZero)
        rightSwitch?.addTarget(self, action: "rightSwitchAction:", forControlEvents: UIControlEvents.ValueChanged)
        rightSwitch?.transform = CGAffineTransformMakeScale(0.7, 0.7)
        rightSwitch?.center = CGPointMake(XuWidth - 45, XuCellHeight / 2)
        contentView.addSubview(rightSwitch!)
    }
    
    func initRightLabel() {
        rightLabel = UILabel(frame: CGRectMake(15, 0, 0, 20))
        rightLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        rightLabel?.center.y = XuCellHeight / 2
        rightLabel?.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(rightLabel!)
    }
    
    func initRightTextField() {
        textField = HoshiTextField(frame: CGRectMake(20,0,XuWidth,self.frame.height - 0))
        textField?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        textField?.setValue(UIFont.systemFontOfSize(20), forKeyPath: "_placeholderLabel.font")
        textField?.autocorrectionType = UITextAutocorrectionType.No
        textField?.center.y = XuCellHeight / 2
        self.contentView.addSubview(textField!)
    }
    
    func setupLeft(image:UIImage,andLabel labelText:String) {
        self.leftLabelText = labelText
        self.leftImage = image
    }
    
    //MARK: --control event
    func rightButtonAction(sender:UIButton) {
        self.rightButtonClicked?()
    }
    
    func rightSwitchAction(sender:UISwitch) {
        delegate?.universalRightSwitchChanged?(self, boolValue: sender.on)
        self.rightSwitchChanged?(sender.on)
    }
    
    //MARK: --XuPickerViewDelegate
    func XuPickerViewDidCancel() {
        textField?.resignFirstResponder()
    }
    
    func XuPickerViewDidSelected(pickerString: String) {
        textField?.text = pickerString
        print(pickerString)
        textField?.resignFirstResponder()
    }
    
    func XupickerViewDidChanged(pickerString: String) {
        textField?.text = pickerString
        print(pickerString)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
