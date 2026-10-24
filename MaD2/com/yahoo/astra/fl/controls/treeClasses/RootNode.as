package com.yahoo.astra.fl.controls.treeClasses
{
   public dynamic class RootNode extends BranchNode
   {
      
      public function RootNode(param1:TreeDataProvider)
      {
         _nodeLevel = -1;
         _nodeType = TreeDataProvider.ROOT_NODE;
         _nodeState = TreeDataProvider.OPEN_NODE;
         super(param1);
      }
      
      override public function set nodeLevel(param1:int) : void
      {
      }
      
      override public function drawNode() : void
      {
         var _loc1_:TNode = null;
         for each(_loc1_ in _children)
         {
            _loc1_.drawNode();
         }
      }
      
      override public function hideNode() : void
      {
      }
      
      override public function addChildNodeAt(param1:TNode, param2:int) : void
      {
         _children.splice(param2,0,param1);
         param1.parentNode = this as BranchNode;
         param1.nodeLevel = this.nodeLevel + 1;
         param1.drawNode();
      }
   }
}

