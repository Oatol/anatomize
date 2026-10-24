package com.yahoo.astra.fl.controls.treeClasses
{
   public dynamic class LeafNode extends TNode
   {
      
      protected var _nodeType:String;
      
      public function LeafNode(param1:TreeDataProvider)
      {
         super(param1);
         this._nodeType = TreeDataProvider.LEAF_NODE;
      }
      
      public function get nodeType() : String
      {
         return this._nodeType;
      }
      
      public function checkForValue(param1:String, param2:String) : TNode
      {
         if(this[param1] == param2)
         {
            return this as TNode;
         }
         return null;
      }
      
      public function getVisibleSize() : int
      {
         return 1;
      }
      
      override public function drawNode() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
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
         }
      }
      
      public function forceDrawNode() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(isVisible())
         {
            if(_parentDataProvider.getItemIndex(this) == -1)
            {
               return;
            }
            _parentDataProvider.removeItem(this);
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
         }
      }
      
      override public function hideNode() : void
      {
         if(_parentDataProvider.getItemIndex(this) != -1 && !isVisible())
         {
            _parentDataProvider.removeItem(this);
         }
      }
   }
}

