package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BubbleTrap extends Trigger
   {
      
      public function BubbleTrap()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Body = null;
         var _loc10_:userData = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         if(_loc7_.length == 1 || Math.random() > 0.8)
         {
            param2.triggerState = 1;
         }
         var _loc8_:String = "forcefield";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc8_ = param2.pfx.getParticle();
         }
         for each(_loc9_ in _loc7_)
         {
            if(_loc9_ != param1)
            {
               _loc9_.WakeUp();
               _loc10_ = userData(_loc9_.GetUserData());
               _loc11_ = bodyCenter.x - _loc9_.GetWorldCenter().x;
               _loc12_ = bodyCenter.y - _loc9_.GetWorldCenter().y;
               _loc13_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
               _loc14_ = new b2Vec2(_loc11_,_loc12_);
               _loc14_.Multiply(0.1 * param2.triggerState * param2.triggerForce * (param2.triggerRadius / _loc13_) * param2.size);
               _loc9_.ApplyForce(_loc14_,_loc9_.GetWorldCenter());
               param1.SetLinearVelocity(new b2Vec2());
               param1.SetAngularVelocity(0);
            }
         }
         if(Math.random() > 0.5)
         {
            _loc15_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,Math.random() * _loc5_,Math.random() * 360);
            GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,_loc8_,(-_loc6_.x + _loc15_.x) * -0.08,(-_loc6_.y + _loc15_.y) * -0.08,1,1);
         }
         if(Math.random() > 0.9)
         {
            _loc16_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,Math.random() * 360);
            GameState.particles.addParticles(_loc16_.x,_loc16_.y,1,_loc8_,(-_loc6_.x + _loc16_.x) * 0.01,(-_loc6_.y + _loc16_.y) * 0.01,1,1);
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         ud.triggerState = -1;
      }
   }
}

