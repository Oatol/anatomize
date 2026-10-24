package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class NitrogenTank extends Trigger
   {
      
      public function NitrogenTank()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = BoxUtils.getEffectBMD(_loc4_);
            if(_loc6_)
            {
               _loc7_ = _loc6_.clone();
               _loc8_ = Math.floor(Math.random() * 10) + 50;
               _loc7_.fillRect(_loc6_.rect,uint(_loc8_ << 24 | 200 << 16 | 255 << 8 | 0xFF));
               _loc6_.copyPixels(_loc7_,_loc6_.rect,new Point(),null,null,true);
            }
            Body.Freeze(_loc4_);
            Body.brittle(_loc4_);
         }
         _loc5_ = 0;
         while(_loc5_ < 20 * param2.size)
         {
            _loc9_ = "snowBig";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc9_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 100 - 50) * param2.size,pixelCenter.y + (Math.random() * 100 - 50) * param2.size,1,_loc9_,bodyVel.x * 0.2,bodyVel.y * 0.2,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < 20 * param2.size)
         {
            _loc9_ = "cloud";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc9_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 100 - 50) * param2.size,pixelCenter.y + (Math.random() * 100 - 50) * param2.size,1,_loc9_,bodyVel.x * 0.2,bodyVel.y * 0.2,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < 40 * param2.size)
         {
            _loc9_ = "snow";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc9_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc9_,bodyVel.x * 0.2,bodyVel.y * 0.2,Math.random() * 10,Math.random() * 10);
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 100 - 50) * param2.size,pixelCenter.y + (Math.random() * 100 - 50) * param2.size,1,_loc9_,bodyVel.x * 0.2,bodyVel.y * 0.2,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         Body.Destroy(param1,"cryo");
         sounds.play("cryo",param1,pixelCenter,0.6);
         sounds.play("incendiary",param1,pixelCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.GetUserData().trigger is NitrogenTank)
         {
            return true;
         }
         if(param4 > 100 * TimeLord.speed)
         {
            ud.triggered = true;
         }
         return true;
      }
   }
}

