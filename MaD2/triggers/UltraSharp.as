package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class UltraSharp extends Trigger
   {
      
      internal var cutRange:Number = 100;
      
      internal var cutPart:String = "";
      
      public function UltraSharp(param1:Number, param2:String)
      {
         super();
         this.cutRange = param1;
         this.cutPart = param2.toLowerCase();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return false;
         }
         if(this.cutPart != "" && param3.name.toLowerCase() != this.cutPart)
         {
            return false;
         }
         var _loc7_:b2Vec2 = param1.GetPosition().Copy();
         _loc7_.Multiply(Physics.scale);
         var _loc8_:b2Vec2 = new b2Vec2((param5.x + (body.GetPosition().x - param5.x) * 0.01) * Physics.scale,(param5.y + (body.GetPosition().y - param5.y) * 0.05) * Physics.scale);
         var _loc9_:Vector.<b2Body> = new Vector.<b2Body>();
         _loc9_.push(param1);
         Main.instance.m_contactListener.addCut("chainsaw",_loc8_,_loc7_,this.cutRange,0,_loc9_,new Vector.<b2Body>());
         return true;
      }
   }
}

