package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Hoverboard extends Trigger
   {
      
      public function Hoverboard()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = 0;
         if(param2.triggerForce > 0)
         {
            _loc3_ = triggerForce;
            param2.triggerForce -= 4;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,5 * param2.size),bodyAngle);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,6 * param2.size),bodyAngle);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc8_:Array = GameState.cutter.CustomRaycast(_loc6_,20,_loc7_,true);
         if(_loc8_[0])
         {
            _loc9_ = bodyVel.Copy();
            _loc9_.y *= 0.95;
            param1.SetLinearVelocity(_loc9_);
            _loc3_ += param1.GetMass() * 2;
         }
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle) * param1.GetMass() * _loc3_ * 12,Math.cos(bodyAngle) * -param1.GetMass() * _loc3_ * 12),bodyCenter);
         param1.ApplyTorque(-bodyAngle * param1.GetMass() * 500);
         param1.WakeUp();
      }
   }
}

