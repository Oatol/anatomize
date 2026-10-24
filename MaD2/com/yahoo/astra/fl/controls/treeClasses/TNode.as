package com.yahoo.astra.fl.controls.treeClasses
{
   public dynamic class TNode
   {
      
      protected var _parentNode:BranchNode;
      
      protected var _nodeLevel:int;
      
      protected var _parentDataProvider:TreeDataProvider;
      
      public function TNode(param1:TreeDataProvider)
      {
         super();
         this._parentDataProvider = param1;
      }
      
      public function isVisible() : Boolean
      {
         var _loc1_:BranchNode = this._parentNode as BranchNode;
         while(!(_loc1_ is RootNode))
         {
            if(!_loc1_.isOpen())
            {
               return false;
            }
            _loc1_ = _loc1_.parentNode;
         }
         return true;
      }
      
      public function drawNode() : void
      {
      }
      
      public function hideNode() : void
      {
      }
      
      public function removeNode() : TNode
      {
         this.parentNode.removeChild(this);
         return this;
      }
      
      public function set nodeLevel(param1:int) : void
      {
         if(param1 == this._parentNode.nodeLevel + 1)
         {
            this._nodeLevel = param1;
         }
      }
      
      public function get nodeLevel() : int
      {
         return this._nodeLevel;
      }
      
      public function set parentNode(param1:BranchNode) : void
      {
         if(param1.children.indexOf(this) >= 0)
         {
            this._parentNode = param1;
         }
      }
      
      public function get parentNode() : BranchNode
      {
         return this._parentNode;
      }
   }
}

