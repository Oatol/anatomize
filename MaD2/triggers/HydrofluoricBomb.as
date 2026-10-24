package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HydrofluoricBomb extends Trigger
   {
      
      public function HydrofluoricBomb()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:userData = null;
         var _loc7_:Number = NaN;
         var _loc8_:BitmapData = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = userData(_loc4_.GetUserData());
            _loc7_ = triggerForce * param2.size / BoxUtils.vectorDist(bodyCenter,_loc4_.GetPosition());
            Body.Damage(_loc4_,_loc7_,new b2Vec2(Math.random() * _loc4_.GetUserData().width * 1 / Physics.scale + _loc4_.GetPosition().x,Math.random() * _loc4_.GetUserData().height * 1 / Physics.scale + _loc4_.GetPosition().y),new b2Vec2(),new b2Vec2(1,1));
            _loc8_ = BoxUtils.getEffectBMD(_loc4_);
            if(_loc8_)
            {
               _loc8_.lock();
               _loc9_ = 0;
               while(_loc9_ < (_loc7_ < 50 ? _loc7_ : 50))
               {
                  _loc8_.copyPixels(R.getSprite("p_smoke"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc4_.GetUserData().width + 10) - 5,Math.random() * (_loc4_.GetUserData().height + 10) - 5),null,null,true);
                  if(_loc9_ < 20)
                  {
                     _loc8_.copyPixels(R.getSprite("p_poison"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc4_.GetUserData().width + 10) - 5,Math.random() * (_loc4_.GetUserData().height + 10) - 5),null,null,true);
                  }
                  _loc8_.copyPixels(R.getSprite("p_blood"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc4_.GetUserData().width + 10) - 5,Math.random() * (_loc4_.GetUserData().height + 10) - 5),null,null,true);
                  _loc9_++;
               }
               _loc8_.unlock();
            }
         }
         _loc5_ = 0;
         while(_loc5_ < 50 * param2.size)
         {
            _loc10_ = "smoke";
            _loc11_ = "poison";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc10_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc10_,bodyVel.x * 0.2,bodyVel.y * 0.2,20,20);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc11_,bodyVel.x * 0.2,bodyVel.y * 0.2,Math.random() * 50,Math.random() * 50);
            _loc5_++;
         }
         Body.Destroy(param1,"triggered");
         sounds.play("incendiary",param1,pixelCenter);
      }
   }
}

