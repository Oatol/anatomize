package com.yahoo.astra.fl.controls.treeClasses
{
   import fl.data.DataProvider;
   
   public class TreeDataProvider extends DataProvider
   {
      
      public static const OPEN_NODE:String = "openNode";
      
      public static const CLOSED_NODE:String = "closedNode";
      
      public static const BRANCH_NODE:String = "branchNode";
      
      public static const LEAF_NODE:String = "leafNode";
      
      public static const ROOT_NODE:String = "rootNode";
      
      private var nodeCounter:int;
      
      public var xml:Object;
      
      public var rootNode:TNode;
      
      public function TreeDataProvider(param1:Object = null)
      {
         data = [];
         super(param1);
         this.xml = param1;
      }
      
      public function toggleNode(param1:int) : void
      {
         var _loc2_:TNode = this.getItemAt(param1) as TNode;
         if(_loc2_ is BranchNode && !(_loc2_ is RootNode))
         {
            if(_loc2_.isOpen())
            {
               _loc2_.closeNode();
            }
            else
            {
               _loc2_.openNode();
            }
         }
      }
      
      private function moveNode(param1:int, param2:int) : void
      {
      }
      
      private function createTreeFromXML(param1:XML) : void
      {
         var _loc2_:XML = null;
         this.rootNode = new RootNode(this);
         this.rootNode.drawNode();
         for each(_loc2_ in param1.children())
         {
            this.parseXMLNode(_loc2_,this.rootNode as BranchNode);
         }
      }
      
      private function parseXMLNode(param1:XML, param2:BranchNode) : void
      {
         var _loc3_:TNode = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         if(param1.children().length() > 0)
         {
            _loc3_ = new BranchNode(this);
         }
         else
         {
            _loc3_ = new LeafNode(this);
         }
         var _loc4_:XMLList = param1.attributes();
         for each(_loc5_ in _loc4_)
         {
            _loc3_[_loc5_.localName()] = _loc5_.toString();
         }
         param2.addChildNode(_loc3_);
         for each(_loc6_ in param1.children())
         {
            this.parseXMLNode(_loc6_,_loc3_ as BranchNode);
         }
      }
      
      private function isTreeNode(param1:Object) : Boolean
      {
         return param1 is TNode;
      }
      
      override protected function getDataFromObject(param1:Object) : Array
      {
         var _loc2_:XML = null;
         if(param1 is XML)
         {
            _loc2_ = param1 as XML;
            this.createTreeFromXML(_loc2_);
            return this.toArray();
         }
         throw new TypeError("Error: Type Coercion failed: cannot convert " + param1 + " to TreeDataProvider.");
      }
   }
}

