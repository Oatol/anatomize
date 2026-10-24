package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CryoGrenade extends Trigger
   {
      
      public function CryoGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:userData = null;
         var _loc7_:BitmapData = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = userData(_loc4_.GetUserData());
            if(!(_loc6_.name == "cryo" || _loc6_.name == "icestaff"))
            {
               Body.Freeze(_loc4_);
               _loc7_ = BoxUtils.getEffectBMD(_loc4_);
               if(_loc7_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < 20)
                  {
                     _loc7_.copyPixels(R.getSprite("p_crystal"),new Rectangle(0,0,8,8),new Point(Math.random() * _loc4_.GetUserData().width,Math.random() * _loc4_.GetUserData().height),null,null,true);
                     _loc8_++;
                  }
               }
            }
         }
         _loc5_ = 0;
         while(_loc5_ < 50 * param2.size)
         {
            _loc9_ = "crystal";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc9_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc9_,bodyVel.x * 0.2,bodyVel.y * 0.2,10,10);
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 100 - 50) * param2.size,pixelCenter.y + (Math.random() * 100 - 50) * param2.size,1,_loc9_,bodyVel.x * 0.2,bodyVel.y * 0.2,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         Body.Destroy(param1,"cryo");
         sounds.play("cryo",param1,pixelCenter);
      }
   }
}

