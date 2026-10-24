package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Spring extends Trigger
   {
      
      public function Spring()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(!ud.triggerForce)
         {
            ud.triggerForce = 110;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         _loc7_ = Math.cos(body.GetAngle() - Vars.PI * 0.5) * body.GetLinearVelocity().Length() * (ud.triggerForce / 100);
         _loc8_ = Math.sin(body.GetAngle() - Vars.PI * 0.5) * body.GetLinearVelocity().Length() * (ud.triggerForce / 100);
         body.SetLinearVelocity(new b2Vec2(_loc7_,_loc8_));
         _loc7_ = Math.cos(param1.GetAngle() - Vars.PI * 0.5) * param1.GetLinearVelocity().Length() * (ud.triggerForce / 100);
         _loc8_ = Math.sin(param1.GetAngle() - Vars.PI * 0.5) * param1.GetLinearVelocity().Length() * (ud.triggerForce / 100);
         param1.SetLinearVelocity(new b2Vec2(_loc7_,_loc8_));
         return false;
      }
   }
}

