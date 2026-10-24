package com.yahoo.astra.fl.controls
{
   import com.yahoo.astra.fl.controls.treeClasses.*;
   import com.yahoo.astra.fl.events.TreeEvent;
   import fl.controls.List;
   import fl.controls.listClasses.*;
   import fl.core.InvalidationType;
   import fl.data.DataProvider;
   import fl.events.*;
   import flash.display.*;
   import flash.events.KeyboardEvent;
   
   public class Tree extends List
   {
      
      public static var createAccessibilityImplementation:Function;
      
      public var leafIconField:String = "leafIcon";
      
      public var openBranchIconField:String = "openBranchIcon";
      
      public var closedBranchIconField:String = "closedBranchIcon";
      
      public function Tree()
      {
         super();
         addEventListener(ListEvent.ITEM_CLICK,this.nodeClick);
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.nodeClick);
         setStyle("cellRenderer",TreeCellRenderer);
      }
      
      public function openAllNodes() : void
      {
         var _loc2_:TNode = null;
         var _loc1_:Array = this.dataProvider.toArray();
         for each(_loc2_ in _loc1_)
         {
            if(!(_loc2_ is LeafNode) && _loc2_.nodeLevel == 0)
            {
               _loc2_.openAllChildren();
            }
         }
      }
      
      public function closeAllNodes() : void
      {
         var _loc2_:TNode = null;
         var _loc1_:Array = this.dataProvider.toArray();
         for each(_loc2_ in _loc1_)
         {
            if(!(_loc2_ is LeafNode) && _loc2_.nodeLevel == 0)
            {
               _loc2_.closeAllChildren();
            }
         }
      }
      
      public function findNode(param1:String, param2:String) : TNode
      {
         var _loc4_:TNode = null;
         var _loc5_:TNode = null;
         var _loc3_:Array = this.dataProvider.toArray();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.nodeLevel == 0)
            {
               _loc5_ = _loc4_.checkForValue(param1,param2);
               if(_loc5_ != null && _loc5_.favourite != "true")
               {
                  return _loc5_;
               }
            }
         }
         return null;
      }
      
      public function getNode(param1:int) : TNode
      {
         var _loc2_:Array = this.dataProvider.toArray();
         return _loc2_[param1];
      }
      
      public function showNode(param1:TNode) : int
      {
         var _loc2_:TNode = null;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc2_ = param1.parentNode;
            while(!(_loc2_ is RootNode))
            {
               _loc2_.openNode();
               _loc2_ = _loc2_.parentNode;
            }
            return this.dataProvider.getItemIndex(param1);
         }
         return -1;
      }
      
      public function exposeNode(param1:String, param2:String) : TNode
      {
         var _loc3_:TNode = this.findNode(param1,param2);
         if(_loc3_ != null)
         {
            this.showNode(_loc3_);
            return _loc3_;
         }
         return null;
      }
      
      public function toggleNode(param1:BranchNode) : void
      {
         if(param1.nodeState == TreeDataProvider.OPEN_NODE)
         {
            param1.closeNode();
         }
         else
         {
            param1.openNode();
         }
      }
      
      private function nodeClick(param1:ListEvent) : void
      {
         var _loc2_:TreeDataProvider = this.dataProvider as TreeDataProvider;
         _loc2_.toggleNode(param1.index);
      }
      
      override public function get labelField() : String
      {
         return _labelField;
      }
      
      override public function set labelField(param1:String) : void
      {
         if(param1 == _labelField)
         {
            return;
         }
         if(param1.substr(0,1) == "@")
         {
            _labelField = param1.substr(1);
         }
         else
         {
            _labelField = param1;
         }
         invalidate(InvalidationType.DATA);
      }
      
      override public function set rowHeight(param1:Number) : void
      {
         super.rowHeight = param1;
         super.verticalLineScrollSize = param1;
      }
      
      override public function get dataProvider() : DataProvider
      {
         return _dataProvider;
      }
      
      override public function set dataProvider(param1:DataProvider) : void
      {
         if(param1 is DataProvider && param1.length == 0 || param1 is TreeDataProvider)
         {
            if(_dataProvider != null)
            {
               _dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange);
               _dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE,onPreChange);
            }
            _dataProvider = param1;
            _dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange,false,0,true);
            _dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE,onPreChange,false,0,true);
            clearSelection();
            invalidateList();
            return;
         }
         throw new TypeError("Error: Type Coercion failed: cannot convert " + param1 + " to TreeDataProvider.");
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:TreeCellRenderer = null;
         var _loc3_:TNode = null;
         var _loc4_:int = 0;
         var _loc5_:BranchNode = null;
         var _loc6_:TreeEvent = null;
         var _loc7_:TreeEvent = null;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Tree.createAccessibilityImplementation != null)
         {
            Tree.createAccessibilityImplementation(this);
         }
      }
   }
}

