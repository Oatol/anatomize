package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CutOnCollision extends Trigger
   {
      
      public function CutOnCollision()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:Number = ud.triggerForce;
         var _loc8_:String = ud.triggerColour;
         if(!ud.triggered)
         {
            return false;
         }
         if(_loc8_ != "" && param3.name.toLowerCase() != _loc8_.toLowerCase())
         {
            return false;
         }
         var _loc9_:b2Vec2 = param1.GetPosition().Copy();
         _loc9_.Multiply(Physics.scale);
         var _loc10_:b2Vec2 = new b2Vec2((param5.x + (body.GetPosition().x - param5.x) * 0.01) * Physics.scale,(param5.y + (body.GetPosition().y - param5.y) * 0.01) * Physics.scale);
         var _loc11_:Vector.<b2Body> = new Vector.<b2Body>();
         _loc11_.push(param1);
         Main.instance.m_contactListener.addCut("chainsaw",_loc10_,_loc9_,_loc7_,0,_loc11_,new Vector.<b2Body>());
         return true;
      }
   }
}

