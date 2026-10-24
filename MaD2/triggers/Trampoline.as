package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Trampoline extends Trigger
   {
      
      public function Trampoline()
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
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:b2Body = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:Array = BoxUtils.selectCompound(param1);
         for each(_loc10_ in _loc7_)
         {
            _loc8_ = Math.cos(body.GetAngle() - Vars.PI * 0.5) * _loc10_.GetLinearVelocity().Length() * (ud.triggerForce / 100);
            _loc9_ = Math.sin(body.GetAngle() - Vars.PI * 0.5) * _loc10_.GetLinearVelocity().Length() * (ud.triggerForce / 100);
            _loc10_.SetLinearVelocity(new b2Vec2(_loc8_,_loc9_));
         }
         return false;
      }
   }
}

