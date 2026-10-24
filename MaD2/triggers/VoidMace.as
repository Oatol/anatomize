package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class VoidMace extends Trigger
   {
      
      public function VoidMace()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:String = null;
         var _loc11_:userData = null;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggered = false;
         }
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ != param1)
            {
               _loc11_ = userData(_loc8_.GetUserData());
               if(!(param2.id != -1 && param2.id == _loc11_.id))
               {
                  if(_loc11_.connected.indexOf(param1) == -1)
                  {
                     _loc12_ = _loc6_.x / Physics.scale - _loc8_.GetWorldCenter().x;
                     _loc13_ = _loc6_.y / Physics.scale - _loc8_.GetWorldCenter().y;
                     _loc14_ = _loc12_ * _loc12_ + _loc13_ * _loc13_;
                     _loc8_.ApplyForce(new b2Vec2(-Vars.wind * _loc8_.GetMass() + _loc12_ * triggerForce * 0.2,-Vars.gravity * _loc8_.GetMass() + _loc13_ * triggerForce * 0.2),_loc8_.GetWorldCenter());
                  }
               }
            }
         }
         _loc9_ = "void";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
         }
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,Math.random() * _loc5_,Math.random() * 360);
         GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc9_,(_loc6_.x - _loc10_.x) * 0.1 + bodyVel.x * 0.1,(_loc6_.y - _loc10_.y) * 0.1 + bodyVel.y * 0.1,1,1);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sharp)
         {
            return false;
         }
         ud.triggered = true;
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
   }
}

