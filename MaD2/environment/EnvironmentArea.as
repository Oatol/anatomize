package environment
{
   import Box2D.Common.Math.b2Vec2;
   
   public class EnvironmentArea
   {
      
      public var items:int = 10;
      
      public var scaleMin:Number = 1;
      
      public var scaleMax:Number = 1;
      
      public var angleMin:Number = 0;
      
      public var angleMax:Number = 0;
      
      public var colourMod:Number = 0;
      
      public var align:String;
      
      public var decorative:Boolean;
      
      public var boundsMin:b2Vec2;
      
      public var boundsMax:b2Vec2;
      
      private var _item:String;
      
      public function EnvironmentArea()
      {
         super();
         this.boundsMin = new b2Vec2(200,200);
         this.boundsMax = new b2Vec2(400,400);
      }
      
      public function get item() : String
      {
         return this._item;
      }
      
      public function set item(param1:String) : void
      {
         this._item = param1;
      }
   }
}

