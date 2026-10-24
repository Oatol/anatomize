package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class RGB extends Trigger
   {
      
      public function RGB()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<Array> = null;
         var _loc11_:* = 0;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Vector.<MyLittleParticle> = null;
         var _loc16_:MyLittleParticle = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.8)
         {
            _loc3_ = new Sprite();
            _loc3_.graphics.lineStyle(2,16711680);
            _loc4_ = Math.random() * 360;
            _loc5_ = param2.triggerForce;
            _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * param2.size,_loc4_);
            _loc7_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc5_,_loc4_);
            _loc8_ = (_loc7_.y - _loc6_.y) / (_loc7_.x - _loc6_.x);
            _loc9_ = 4294901760;
            _loc10_ = param2.skin;
            if((Boolean(_loc10_)) && _loc10_.length > 0)
            {
               _loc9_ = 4278190080 + BoxUtils.getSkinColour(_loc10_,"FF0000");
            }
            if(Math.random() > 0.8)
            {
               sounds.play("random",param1,null,1,false,-1);
            }
            _loc11_ = 30;
            while(_loc11_ > 0)
            {
               _loc12_ = "laser";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc12_ = param2.pfx.getParticle();
               }
               _loc13_ = _loc6_.x + _loc11_ / 30 * (_loc7_.x - _loc6_.x) + Math.random() * 8 - 4;
               _loc14_ = _loc6_.y + _loc8_ * (_loc13_ - _loc6_.x) + Math.random() * 8 - 4;
               _loc15_ = GameState.particles.addParticles(_loc13_,_loc14_,1,_loc12_,(-_loc13_ + _loc7_.x) * 0.5,(-_loc14_ + _loc7_.y) * 0.5,0,0);
               if((Boolean(_loc15_)) && _loc15_.length > 0)
               {
                  for each(_loc16_ in _loc15_)
                  {
                     _loc16_.colour = _loc9_;
                  }
               }
               _loc11_--;
            }
         }
      }
   }
}

