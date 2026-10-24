package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Spellbook extends Trigger
   {
      
      public function Spellbook()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:b2Body = null;
         var _loc6_:String = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         super.trigger(param1,param2);
         if(param2.triggerDuration >= 60)
         {
            _loc3_ = 0;
            while(_loc3_ < 50)
            {
               _loc6_ = "blood";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
               }
               _loc7_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * param2.size,Math.random() * 360);
               GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,_loc6_,(pixelCenter.x - _loc7_.x) * 0.01 + bodyVel.x * 0.1,(pixelCenter.y - _loc7_.y) * 0.01 + bodyVel.y * 0.1 - 1,1,1);
               _loc3_++;
            }
            _loc4_ = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
            for each(_loc5_ in _loc4_)
            {
               if(userData(_loc5_.GetUserData()).alive)
               {
                  if(Math.random() > 0.5)
                  {
                     _loc8_ = pixelCenter.Copy();
                     _loc9_ = _loc5_.GetWorldCenter().Copy();
                     _loc9_.Multiply(Physics.scale);
                     _loc10_ = (_loc9_.y - pixelCenter.y) / (_loc9_.x - pixelCenter.x);
                     _loc11_ = 0;
                     while(_loc11_ < 20)
                     {
                        _loc6_ = "blood";
                        if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                        {
                           _loc6_ = param2.pfx.getParticle();
                        }
                        _loc12_ = _loc8_.x + _loc11_ / 20 * (_loc9_.x - _loc8_.x);
                        _loc13_ = _loc8_.y + _loc10_ * (_loc12_ - _loc8_.x);
                        GameState.particles.addParticles(_loc12_,_loc13_,1,_loc6_,(_loc8_.x - _loc12_) * 0.03,(_loc8_.y - _loc13_) * 0.03,2,2);
                        _loc11_++;
                     }
                     userData(_loc5_.GetUserData()).trigger = new Disintegrate("blood",100,0.5);
                     userData(_loc5_.GetUserData()).triggered = true;
                  }
               }
            }
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration < 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
         }
      }
   }
}

