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
    var leftShift:CGFloat = 0
    
    var leftImage:UIImage? {
        didSet{
            guard leftImageView != nil else {return}
            leftImageView?.frame = CGRectMake(0, 0, 30, 30 * leftImage!.size.height / leftImage!.size.width)
            leftImageView?.image = leftImage
            leftImageView?.center = CGPointMake(35, AlStyle.cellHeight / 2)
            guard leftLabel != nil else {return}
            leftLabel?.center.x += 40
        }
    }
    
    var leftLabelText:String? {
        didSet{
            guard leftLabel != nil else {return}
            leftLabel?.text = leftLabelText
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
                rightSwitch?.center.x = AlStyle.size.width - 35
            }
        }
    }
    
    var rightLabelText:String? {
        didSet{
            guard rightLabel != nil && rightLabelText != nil else {return}
            rightLabel?.text = rightLabelText
            if NSString.init(string: rightLabelText!).length > 15 {
                rightLabel?.numberOfLines = 0
                rightLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            }
        }
    }
    
    var rightButtonTitle:String? {
        didSet{
            self.initRightButton()
            rightButton?.setTitle(rightButtonTitle, forState: UIControlState.Normal)
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
            (rightObject as! UIView).center = CGPointMake(AlStyle.size.width - CGRectGetWidth((rightObject as! UIView).frame) / 2 - 30, AlStyle.cellHeight / 2)
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
        leftLabel?.font = AlStyle.font.normal
        self.contentView.addSubview(leftLabel!)
    }
    
    func initLeftImageView() {
        leftImageView = UIImageView()
        self.contentView.addSubview(leftImageView!)
    }
    
    func initRightButton() {
        rightButton = UIButton(type: UIButtonType.Custom)
//        rightButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightButton?.titleLabel?.font = AlStyle.font.normal
        rightButton?.backgroundColor = AlStyle.color.blue
        rightButton?.layer.cornerRadius = AlStyle.cornerRadius
        rightButton?.addTarget(self, action: #selector(UniversalTableViewCell.rightButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(rightButton!)
    }
    
    func initRightSwitch() {
        rightSwitch = UISwitch(frame: CGRectZero)
        rightSwitch?.addTarget(self, action: #selector(UniversalTableViewCell.rightSwitchAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        rightSwitch?.transform = CGAffineTransformMakeScale(0.7, 0.7)
        rightSwitch?.center = CGPointMake(AlStyle.size.width - 45, AlStyle.cellHeight / 2)
        contentView.addSubview(rightSwitch!)
    }
    
    func initRightLabel() {
        rightLabel = UILabel(frame: CGRectMake(15, 0, 0, 20))
        rightLabel?.font = AlStyle.font.normal
        rightLabel?.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(rightLabel!)
    }
    
    func initRightTextField() {
        textField = HoshiTextField(frame: CGRectMake(20,0,AlStyle.size.width,self.frame.height - 0))
        textField?.font = AlStyle.font.normal
        textField?.setValue(UIFont.systemFontOfSize(20), forKeyPath: "_placeholderLabel.font")
        textField?.autocorrectionType = UITextAutocorrectionType.No
        textField?.center.y = AlStyle.cellHeight / 2
        self.contentView.addSubview(textField!)
        textField?.addTarget(self, action: #selector(UniversalTableViewCell.textFieldValueChanged(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
    }
    
    func setupLeft(image:UIImage,andLabel labelText:String) {
        self.leftLabelText = labelText
        self.leftImage = image
    }
    
    //MARK: --control event
    func rightButtonAction(sender:UIButton) {
        self.rightButtonClicked?()
    }
    
    func textFieldValueChanged(textField:UITextField) {
//        print("\(textField.text):::\(XuRegularExpression.isVaild(textField.text, fortype: XuRegularType.secure))")
        
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
    
    override func layoutSubviews() {
        rightButton?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView.snp_centerY)
            make.height.equalTo(AlStyle.font.normal.pointSize + 5)
        })
        rightLabel?.snp_makeConstraints(closure: { (make) in
            if rightButton != nil {
                make.right.equalTo(rightButton!.snp_left).offset(-10)
            }else {
                make.right.equalTo(contentView).offset(-20)
            }
            make.centerY.equalTo(contentView.snp_centerY)
        })
        
        leftLabel?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(contentView).offset(20 + leftShift)
            make.centerY.equalTo(contentView)
        })
        
        rightLabel?.snp_makeConstraints(closure: { (make) in
            make.centerY.equalTo(contentView)
            make.width.lessThanOrEqualTo(AlStyle.XuWidth * 0.6)
            if rightButton != nil {
                make.right.equalTo(rightButton!.snp_left).offset(-10)
            }else {
                make.right.equalTo(contentView).offset(-20)
            }
        })
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
