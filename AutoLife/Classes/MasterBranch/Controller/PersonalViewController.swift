//
//  PersonalViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//
import UIKit

class PersonalViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var collectionView:UICollectionView!
    private let reuseCell = "cell"
    private let keys = ["账号","昵称","电子邮箱"]
    private let datas:NSDictionary = ["账号":"18713454687","昵称":"爱车人","电子邮箱":"188186166@qq.com"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = XuColorGrayThin
        self.navigationItem.title = "个人资料"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMessageView:")
        self.initCollectionView()
    }
    
    func initCollectionView() {
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: PersonCollectionViewLayout())
        collectionView.layer.borderWidth = 10
        collectionView.layer.borderColor = XuColorGrayThin.CGColor
        collectionView.backgroundColor = XuColorGrayThin
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        collectionView.registerClass(PersonCollectionCell.self, forCellWithReuseIdentifier: reuseCell)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: XuCollectionAttributesType.Header, withReuseIdentifier: XuCollectionAttributesType.Header)
        collectionView.registerClass(PersonCollectionReusableView.self, forSupplementaryViewOfKind: XuCollectionAttributesType.Footer, withReuseIdentifier: XuCollectionAttributesType.Footer)
    }
    
    //MARK: --UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath)
            let imageView = UIImageView(frame: CGRectMake(20, 10, 80, 80))
            imageView.image = UIImage(named: "addhead")
            cell.contentView.addSubview(imageView)
            return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCell, forIndexPath: indexPath) as! PersonCollectionCell
        cell.leftText = keys[indexPath.row - 1]
        cell.rightText = datas[cell.leftText!] as? String
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == XuCollectionAttributesType.Header {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kind, forIndexPath: indexPath)
            return view
        }else if kind == XuCollectionAttributesType.Footer {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kind, forIndexPath: indexPath) as? PersonCollectionReusableView
            view?.buttonClosure = { (_) in
                print(indexPath.section)
            }
            return view!
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
   
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let layer = CAShapeLayer();let pathRef = CGPathCreateMutable();let bounds = CGRectInset(cell.bounds, 10, 0)
        let lineHeight = 1 / UIScreen.mainScreen().scale
        switch indexPath.row {
        case 0:
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), XuCornerRadius)
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), 0)
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
            let verticalLine = CALayer()
            verticalLine.frame = CGRectMake(CGRectGetMaxX(bounds) - lineHeight, CGRectGetMinY(bounds), lineHeight, bounds.height)
            verticalLine.backgroundColor = XuColorGrayThin.CGColor
            layer.addSublayer(verticalLine)
        case 1:
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), 0)
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), XuCornerRadius)
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        case 3:
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), XuCornerRadius)
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), XuCornerRadius)
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        default:CGPathAddRect(pathRef, nil, bounds)
        }
        layer.path = pathRef
        layer.fillColor = XuColorWhite.CGColor
        let lineLayer = CALayer()
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height - lineHeight, bounds.size.width, lineHeight)
        lineLayer.backgroundColor = XuColorGrayThin.CGColor
        layer.addSublayer(lineLayer)
        let view = UIView(frame: bounds)
        view.layer.insertSublayer(layer, atIndex: 0)
        view.backgroundColor = UIColor.clearColor()
        cell.backgroundView = view
    }
    
    //MARK: --ControllerAction
    func showMessageView(sender:UIBarButtonItem) {
        let messageVC = MessageViewController()
        self.navigationController?.pushViewController(messageVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct XuCollectionAttributesType {
    static let Cell = "cell"
    static let Header = "header"
    static let Footer = "footer"
}

class PersonCollectionViewLayout: UICollectionViewLayout {
    
    var allAttributes:NSMutableDictionary = [:]
    
    var numberOfSections:Int {
        get{
            return (self.collectionView?.numberOfSections())!
        }
    }
    
    override func prepareLayout() {
        let cells:NSMutableDictionary = [:]
        let headers:NSMutableDictionary = [:];let footers:NSMutableDictionary = [:]
        for var section = 0;section < self.numberOfSections;section++ {
            for var row = 0;row < self.collectionView?.numberOfItemsInSection(section);row++ {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                switch indexPath.row {
                case 0:
                    attributes.frame = CGRectMake(0, 20, 120, 100)
                    let headerAttribues = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: XuCollectionAttributesType.Header, withIndexPath: indexPath)
                    headerAttribues.frame = CGRectMake(0, 0, XuWidth, 20)
                    headers[indexPath] = headerAttribues
                case 1:
                    attributes.frame = CGRectMake(100, 20, XuWidth - 100, 50)
                case 2:
                    attributes.frame = CGRectMake(100, 70, XuWidth - 100, 50)
                case 3:
                    attributes.frame = CGRectMake(0, 120, XuWidth, 50)
                    let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: XuCollectionAttributesType.Footer, withIndexPath: indexPath)
                    footerAttributes.frame = CGRectMake(0, 170, XuWidth, 30)
                    footers[indexPath] = footerAttributes
                default:break
                }
                cells[indexPath] = attributes
            }
        }
        self.allAttributes[XuCollectionAttributesType.Header] = headers
        self.allAttributes[XuCollectionAttributesType.Cell] = cells
        self.allAttributes[XuCollectionAttributesType.Footer] = footers
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let allAttribues:NSMutableArray = []
        self.allAttributes.enumerateKeysAndObjectsUsingBlock { (key, dic, _) -> Void in
            dic.enumerateKeysAndObjectsUsingBlock({ (indexPath, attributes, _) -> Void in
                if CGRectIntersectsRect(rect, attributes.frame) {
                    allAttribues.addObject(attributes)
                }
            })
        }
        return NSArray(array: allAttribues) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.allAttributes[XuCollectionAttributesType.Cell]![indexPath] as? UICollectionViewLayoutAttributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(self.collectionView!.frame.width , 0)
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let a = self.allAttributes[elementKind]![indexPath] as? UICollectionViewLayoutAttributes
        return a
    }
}

class PersonCollectionCell: UICollectionViewCell {
    private var leftLabel:UILabel?
    private var rightLabel:UILabel?
    
    var leftText:String? {
        didSet{
            let width = CGFloat (NSString(string: leftText!).length) * XuTextSizeSmall
            leftLabel?.frame.size.width = width + 10
            leftLabel?.center.y = self.frame.height / 2
            leftLabel?.text = leftText
        }
    }
    
    var rightText:String? {
        didSet{
            let width = CGFloat (NSString(string: rightText!).length) * XuTextSizeSmall
            rightLabel?.frame.size.width = width + 10
            rightLabel?.center.y = self.frame.height / 2
            rightLabel?.center.x = self.frame.width - width / 2 - 25
            rightLabel?.text = rightText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftLabel = UILabel(frame: CGRectMake(20,0,20,20))
        leftLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        self.addSubview(leftLabel!)
        
        rightLabel = UILabel(frame: CGRectMake(0,0,20,20))
        rightLabel?.font = UIFont.systemFontOfSize(XuTextSizeSmall)
        rightLabel?.textAlignment = NSTextAlignment.Right
        self.addSubview(rightLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PersonCollectionReusableView: UICollectionReusableView {
    
    var buttonClosure:((UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(XuWidth - 85, 5, 70, 20)
        button.setTitle("添加驾驶员", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(XuTextSizeMiddle)
        button.setTitleColor(XuColorBlueThin, forState: UIControlState.Normal)
        button.addTarget(self, action: "addDriver:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        
        let addBtn = UIButton(type: UIButtonType.System)
        addBtn.frame = CGRectMake(CGRectGetMinX(button.frame) - 35, 8, 25, 15)
        addBtn.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        addBtn.addTarget(self, action: "addDriver:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addBtn)
    }
    
    func addDriver(button:UIButton) {
        self.buttonClosure?(button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

