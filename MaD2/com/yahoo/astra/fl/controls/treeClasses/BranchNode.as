package com.yahoo.astra.fl.controls.treeClasses
{
   public dynamic class BranchNode extends TNode
   {
      
      protected var _children:Array;
      
      protected var state:Boolean;
      
      protected var _nodeType:String;
      
      protected var _nodeState:String;
      
      public function BranchNode(param1:TreeDataProvider)
      {
         super(param1);
         this._nodeType = TreeDataProvider.BRANCH_NODE;
         this._nodeState = TreeDataProvider.CLOSED_NODE;
         this._children = [];
         this.state = false;
      }
      
      public function get nodeType() : String
      {
         return this._nodeType;
      }
      
      public function get nodeState() : String
      {
         return this._nodeState;
      }
      
      public function isOpen() : Boolean
      {
         return this.state;
      }
      
      public function getVisibleSize() : int
      {
         var _loc2_:TNode = null;
         var _loc1_:int = 0;
         if(!this.isVisible())
         {
            return 0;
         }
         if(!this.isOpen())
         {
            return 1;
         }
         for each(_loc2_ in this._children)
         {
            if(_loc2_ is LeafNode || !_loc2_.isOpen())
            {
               _loc1_ += 1;
            }
            else if(_loc2_ is BranchNode && Boolean(_loc2_.isOpen()))
            {
               _loc1_ += _loc2_.getVisibleSize();
            }
         }
         return _loc1_ + 1;
      }
      
      override public function drawNode() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TNode = null;
         if(_parentDataProvider.getItemIndex(this) == -1 && isVisible())
         {
            _loc1_ = _parentNode.children.indexOf(this);
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ += _parentNode.children[_loc3_].getVisibleSize();
               _loc3_++;
            }
            if(_parentNode is RootNode)
            {
               if(_parentDataProvider.length > 0)
               {
                  _parentDataProvider.addItemAt(this,_loc2_);
               }
               else
               {
                  _parentDataProvider.addItem(this);
               }
            }
            else
            {
               _loc4_ = _parentDataProvider.getItemIndex(_parentNode);
               _parentDataProvider.addItemAt(this,_loc4_ + _loc2_ + 1);
            }
            if(this.isOpen())
            {
               for each(_loc5_ in this._children)
               {
                  _loc5_.drawNode();
               }
            }
         }
      }
      
      override public function hideNode() : void
      {
         var _loc1_:TNode = null;
         if(_parentDataProvider.getItemIndex(this) != -1 && !isVisible())
         {
            _parentDataProvider.removeItem(this);
            for each(_loc1_ in this._children)
            {
               _loc1_.hideNode();
            }
         }
      }
      
      public function closeNode() : void
      {
         var _loc1_:TNode = null;
         this.state = false;
         this._nodeState = TreeDataProvider.CLOSED_NODE;
         for each(_loc1_ in this._children)
         {
            _loc1_.hideNode();
         }
      }
      
      public function openNode() : void
      {
         var _loc1_:TNode = null;
         this.state = true;
         this._nodeState = TreeDataProvider.OPEN_NODE;
         for each(_loc1_ in this._children)
         {
            _loc1_.drawNode();
         }
      }
      
      public function checkForValue(param1:String, param2:String) : TNode
      {
         var _loc3_:TNode = null;
         var _loc4_:TNode = null;
         if(this[param1] == param2)
         {
            return this as TNode;
         }
         for each(_loc3_ in this._children)
         {
            _loc4_ = _loc3_.checkForValue(param1,param2);
            if(_loc4_ != null)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function openAllChildren() : void
      {
         var _loc1_:TNode = null;
         this.openNode();
         for each(_loc1_ in this._children)
         {
            if(_loc1_ is BranchNode)
            {
               _loc1_.openAllChildren();
            }
         }
      }
      
      public function closeAllChildren() : void
      {
         var _loc1_:TNode = null;
         this.closeNode();
         for each(_loc1_ in this._children)
         {
            if(_loc1_ is BranchNode)
            {
               _loc1_.closeAllChildren();
            }
         }
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function addChildNodeAt(param1:TNode, param2:int) : void
      {
         this._children.splice(param2,0,param1);
         param1.parentNode = this;
         param1.nodeLevel = this.nodeLevel + 1;
         if(this.isOpen() && isVisible())
         {
            param1.drawNode();
         }
      }
      
      public function addChildNode(param1:TNode) : void
      {
         this.addChildNodeAt(param1,this._children.length);
      }
      
      public function removeChild(param1:TNode) : TNode
      {
         var _loc2_:int = this._children.indexOf(param1);
         if(_loc2_ >= 0)
         {
            param1.hideNode();
            this._children.splice(_loc2_,1);
            return param1;
         }
         return null;
      }
   }
}

