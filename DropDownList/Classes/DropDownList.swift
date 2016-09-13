//
//  DropDownList.swift
//  IssueManager
//
//  Created by Satyen on 11/07/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
class DropDownList: UITextField, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    var tblView:UITableView!
    var arrV:NSArray=NSArray()
    static var arrList:NSArray!
    var isArrayWithObject:Bool = false
    var isDismissWhenSelected = false
    var isKeyboardHidden=false
    var keyPath:String!
    var textField:UITextField!
    var arrFiltered:NSArray!
    var superViews:UIView!
    weak var delegates:DropDownListDelegate!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate=self
        self.tblView=UITableView()
        
        self.tblView.delegate=self
        self.tblView.dataSource=self
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellIdentity")
    }
    convenience init(){
        self.init()
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let pred=NSPredicate(format: "name beginswith[c] '\(textField.text! + string)'")
        print(pred)
        self.arrFiltered = self.arrV.filteredArrayUsingPredicate(pred)
        print(self.arrFiltered)
        self.tblView.reloadData()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.tblView.frame.size.height > 0{
            UIView.animateWithDuration(0.5, animations: {
                self.tblView.frame.size.height=0
            })
        }else{
            textField.resignFirstResponder()
            self.tblView.frame.size.width=textField.frame.size.width
            self.tblView.frame.origin.x=textField.frame.origin.x
            self.tblView.frame.size.height=0
            self.tblView.layer.borderWidth = 1
            self.tblView.layer.borderColor = textField.layer.borderColor
            self.textField=textField
            
            self.arrFiltered = self.arrV
            
            self.getSuperView(self.superview!)
            let rect = superViews.convertRect(textField.frame, fromView: textField.superview)
            self.tblView.frame.origin.y = rect.origin.y + rect.size.height-2
            self.tblView.frame.origin.x = rect.origin.x
            
            UIView.animateWithDuration(0.5, animations: {
                self.tblView.frame.size.height=200
                self.superViews.addSubview(self.tblView)
                self.tblView.reloadData()
            })
            
            
        }
        return !isKeyboardHidden
    }
    func getSuperView(views:UIView){
        superViews = views.superview
        if superViews.frame.size.height < 200{
            getSuperView(superViews!)
        }
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.5, animations: {
            self.tblView.frame.size.height=0
        })
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, animations: {
            self.tblView.frame.size.height=0
            
        })
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.5, animations: {
            self.tblView.frame.size.height=0
        })
        textField.resignFirstResponder()
        // self.tblView.removeFromSuperview()
        return true
    }
    //MARK- TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFiltered.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentity")
        cell?.textLabel?.text="hello"
        if isArrayWithObject {
            cell?.textLabel?.text = self.arrFiltered.objectAtIndex(indexPath.row).valueForKey(keyPath) as? String
            
        }else{
            cell?.textLabel?.text=self.arrFiltered.objectAtIndex(indexPath.row) as? String
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegates.dropDownSelectedIndex(indexPath.row, textField: self.textField, object: self.arrFiltered.objectAtIndex(indexPath.row))
        if isDismissWhenSelected {
            UIView.animateWithDuration(0.5, animations: {
                self.tblView.frame.size.height=0
                }, completion: { (value: Bool) in
                    self.tblView.removeFromSuperview()
                    self.resignFirstResponder()
            })
            
        }
    }
}
protocol DropDownListDelegate:class {
    func dropDownSelectedIndex(index:Int, textField:UITextField, object:AnyObject)
}

