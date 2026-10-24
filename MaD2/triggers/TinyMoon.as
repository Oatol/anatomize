package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TinyMoon extends Trigger
   {
      
      public function TinyMoon()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_);
         if(_loc4_.length > 0)
         {
            param1.WakeUp();
            param1.ApplyForce(new b2Vec2(0,-Vars.gravity * param1.GetMass()),bodyCenter);
         }
         for each(_loc5_ in _loc4_)
         {
            _loc5_.WakeUp();
            _loc6_ = userData(_loc5_.GetUserData());
            _loc7_ = bodyCenter.x - _loc5_.GetWorldCenter().x;
            _loc8_ = bodyCenter.y - _loc5_.GetWorldCenter().y;
            _loc9_ = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
            _loc10_ = new b2Vec2(_loc7_,_loc8_);
            _loc10_.Multiply(param2.triggerForce * 0.01 * (param2.triggerRadius / _loc9_) * param2.size);
            _loc11_ = _loc10_.Copy();
            _loc11_.Multiply(-1 * param2.size);
            param1.ApplyForce(_loc11_,bodyCenter);
         }
      }
   }
}

