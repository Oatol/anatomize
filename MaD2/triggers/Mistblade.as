package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Mistblade extends Trigger
   {
      
      public function Mistblade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc11_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = Math.random() * 50 - 10;
         var _loc4_:b2Vec2 = new b2Vec2(0,-15 * param2.size);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc7_:b2Vec2 = new b2Vec2(Math.sin(_loc3_),_loc3_);
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(_loc7_,bodyAngle);
         var _loc9_:String = "trailblazer";
         var _loc10_:String = "forcefield";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
            _loc10_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc6_.x + _loc8_.x * param2.size,_loc6_.y + _loc8_.y * param2.size,1,_loc9_,-bodyVel.x,-bodyVel.y,0,0);
         if(param2.triggerRadius > 10)
         {
            _loc11_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,triggerRadius,Math.random() * 360);
            GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc10_,(_loc6_.x - _loc11_.x) * 0.1 + bodyVel.x * 0.1,(_loc6_.y - _loc11_.y) * 0.1 + bodyVel.y * 0.1,1,1);
         }
         if(triggerDuration > 0)
         {
            this.OnTrigger();
         }
         if(param2.triggerDuration != 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         if(param2.triggerRadius != 0)
         {
            param2.triggerRadius -= TimeLord.speed * 8;
         }
         if(triggerDuration < -60 || param2.triggerRadius <= 0)
         {
            param2.triggerDuration = 0;
            param2.triggerRadius = 0;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggerDuration == 0)
         {
            ud.triggerDuration = param4 * 0.1;
            ud.triggerRadius = param4 * 0.5;
         }
         return true;
      }
      
      public function OnTrigger() : void
      {
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc1_:b2Vec2 = pixelCenter;
         var _loc2_:Number = ud.triggerRadius * ud.size;
         var _loc3_:Array = Body.GetAroundPoint(_loc1_,_loc2_,_loc2_,false);
         var _loc4_:b2Body = _loc3_[Math.random() * _loc3_.length >> 0];
         if((Boolean(_loc4_)) && _loc4_ != body)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            _loc5_.trigger = new Electrified();
            _loc5_.triggered = true;
            _loc5_.triggerDuration = 4;
            Body.Damage(_loc4_,Math.random() * 24 + 12,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            _loc6_ = GeneralUtils.pointOnCircle(_loc1_.x,_loc1_.y,20 * ud.size,Math.random() * 360);
            _loc7_ = _loc4_.GetWorldCenter().Copy();
            _loc7_.Multiply(Physics.scale);
            _loc8_ = (_loc7_.y - _loc1_.y) / (_loc7_.x - _loc1_.x);
            _loc9_ = 2;
            _loc10_ = 0;
            while(_loc10_ < 10 * _loc9_)
            {
               _loc11_ = _loc6_.x + _loc10_ / (10 * _loc9_) * (_loc7_.x - _loc6_.x);
               _loc12_ = _loc6_.y + _loc8_ * (_loc11_ - _loc6_.x);
               _loc13_ = "trailblazer";
               if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
               {
                  _loc13_ = ud.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc11_,_loc12_,1,_loc13_,(-_loc6_.x + _loc11_) * 0.05,(-_loc6_.y + _loc12_) * 0.05,2 * _loc9_,2 * _loc9_);
               _loc10_++;
            }
         }
      }
   }
}

