package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class ArcGrenade extends Trigger
   {
      
      public function ArcGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:b2Body = null;
         var _loc7_:Number = NaN;
         var _loc8_:BitmapData = null;
         var _loc9_:userData = null;
         var _loc10_:Sprite = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         super.trigger(param1,param2);
         if(triggerDuration < 0)
         {
            param2.triggered = false;
            return;
         }
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:String = "trailblazer";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         if((triggerDuration >> 0) % 29 == 0 && triggerDuration > 28)
         {
            sounds.play("ui_hover",param1,pixelCenter);
         }
         else
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1,200 * param2.size,200 * param2.size);
         }
         if(triggerDuration <= 10)
         {
            if(triggerDuration >> 0 == 10)
            {
               sounds.play("arcgrenade",param1,pixelCenter,0.8);
            }
            if(param2.triggerDuration <= 0)
            {
               param2.dead = true;
            }
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1,200 * param2.size,200 * param2.size);
               _loc4_++;
            }
            _loc5_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = triggerForce * 5;
               Body.Damage(_loc6_,_loc7_ * TimeLord.speed * 2,pixelCenter,new b2Vec2(),new b2Vec2(),false);
               if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
               {
                  _loc8_ = BoxUtils.getEffectBMD(_loc6_);
                  if(_loc8_)
                  {
                     _loc9_ = userData(_loc6_.GetUserData());
                     _loc10_ = new Sprite();
                     _loc10_.graphics.lineStyle(0,0,0);
                     _loc13_ = 0;
                     while(_loc13_ < param2.triggerForce)
                     {
                        if(Math.random() > 0.5)
                        {
                           _loc10_.graphics.beginFill(399674,Math.random());
                        }
                        else
                        {
                           _loc10_.graphics.beginFill(39423,Math.random());
                        }
                        _loc11_ = -10 + Math.random() * (_loc9_.width + 20);
                        _loc12_ = -10 + Math.random() * (_loc9_.height + 20);
                        _loc10_.graphics.drawRect(_loc11_,_loc12_,Math.random() * 5,Math.random() * 5);
                        _loc10_.graphics.endFill();
                        _loc13_++;
                     }
                     _loc8_.draw(_loc10_);
                  }
               }
            }
         }
      }
   }
}

