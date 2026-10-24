package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PetrifyRadius extends Trigger
   {
      
      public function PetrifyRadius()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:String = null;
         var _loc7_:userData = null;
         var _loc8_:BitmapData = null;
         var _loc9_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            if(param2.ignored.indexOf(_loc4_) == -1)
            {
               if(param2.connected.indexOf(_loc4_) == -1)
               {
                  _loc7_ = userData(_loc4_.GetUserData());
                  if(!_loc7_.petrified)
                  {
                     Body.Petrify(_loc4_);
                     sounds.play("petrify",param1,pixelCenter,0.4);
                     _loc8_ = BoxUtils.getEffectBMD(_loc4_);
                     if(_loc8_)
                     {
                        _loc9_ = 0;
                        while(_loc9_ < 20)
                        {
                           _loc8_.copyPixels(R.getSprite("p_petrify"),new Rectangle(0,0,8,8),new Point(Math.random() * _loc4_.GetUserData().width,Math.random() * _loc4_.GetUserData().height),null,null,true);
                           _loc9_++;
                        }
                     }
                  }
               }
            }
         }
         _loc5_ = "petrify";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         var _loc6_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * 1.5,Math.random() * 360);
         if(Math.random() > 0.9)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc5_,(_loc6_.x - pixelCenter.x) * 0.01 + bodyVel.x * 0.2,(_loc6_.y - pixelCenter.y) * 0.01 + bodyVel.y * 0.2,10,10);
         }
         GameState.particles.addParticles(_loc6_.x + Math.random() * 4 - 2,_loc6_.y + Math.random() * 4 - 2,1,_loc5_,(_loc6_.x - pixelCenter.x) * -0.1 + bodyVel.x * 0.2,(_loc6_.y - pixelCenter.y) * -0.1 + bodyVel.y * 0.2,1,1);
      }
   }
}

