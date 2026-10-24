package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PhosphorusGrenade extends Trigger
   {
      
      internal var effectMultiplier:Number = 1;
      
      internal var sfx:Boolean = true;
      
      public function PhosphorusGrenade(param1:Number = 1, param2:Boolean = true)
      {
         super();
         this.effectMultiplier = param1;
         this.sfx = param2;
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
            if(_loc6_.alive)
            {
               _loc7_ = triggerForce * param2.size / BoxUtils.vectorDist(bodyCenter,_loc4_.GetPosition());
               Body.Damage(_loc4_,_loc7_,new b2Vec2(Math.random() * _loc4_.GetUserData().width * 1 / Physics.scale + _loc4_.GetPosition().x,Math.random() * _loc4_.GetUserData().height * 1 / Physics.scale + _loc4_.GetPosition().y),new b2Vec2(),new b2Vec2(1,1));
               _loc7_ *= this.effectMultiplier;
               _loc8_ = BoxUtils.getEffectBMD(_loc4_);
               if(_loc8_)
               {
                  _loc8_.lock();
                  _loc9_ = 0;
                  while(_loc9_ < (_loc7_ < 50 ? _loc7_ : 50))
                  {
                     _loc8_.copyPixels(R.getSprite("p_smoke"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc4_.GetUserData().width + 10) - 5,Math.random() * (_loc4_.GetUserData().height + 10) - 5),null,null,true);
                     _loc8_.copyPixels(R.getSprite("p_smoothblood"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc4_.GetUserData().width + 10) - 5,Math.random() * (_loc4_.GetUserData().height + 10) - 5),null,null,true);
                     _loc9_++;
                  }
                  _loc8_.unlock();
               }
            }
         }
         _loc5_ = 0;
         while(_loc5_ < 50 * param2.size)
         {
            _loc10_ = "fire2";
            _loc11_ = "smoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc10_ = param2.pfx.getParticle();
               _loc11_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc10_,bodyVel.x * 0.2,bodyVel.y * 0.2,10,10);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc11_,bodyVel.x * 0.2,bodyVel.y * 0.2,10,10);
            _loc5_++;
         }
         Body.Destroy(param1,"triggered");
         if(this.sfx)
         {
            sounds.play("incendiary",param1,pixelCenter);
         }
      }
   }
}

