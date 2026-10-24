package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class FierySword extends Trigger
   {
      
      public function FierySword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            --param2.triggerDuration;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
      }
      
      public function Effect(param1:b2Body) : *
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:String = null;
         var _loc2_:userData = param1.GetUserData() as userData;
         var _loc3_:b2Vec2 = param1.GetPosition();
         if(World.toggleGore == 0)
         {
            return;
         }
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:Sprite = new Sprite();
         var _loc6_:int = Math.random() * 15 + 5;
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_)
         {
            if(Math.random() > 0.3)
            {
               _loc5_.graphics.beginFill(2236962,Math.random());
            }
            else
            {
               _loc5_.graphics.beginFill(_loc2_.bloodColour,Math.random());
            }
            _loc7_ = -10 + Math.random() * (_loc2_.width + 20);
            _loc8_ = -10 + Math.random() * (_loc2_.height + 20);
            _loc5_.graphics.drawCircle(_loc7_,_loc8_,Math.random() * 5);
            _loc5_.graphics.endFill();
            _loc7_ -= _loc2_.width * 0.5;
            _loc8_ -= _loc2_.height * 0.5;
            _loc10_ = ["fire2","fire3","smoke"][Math.random() * 3 >> 0];
            if(Boolean(ud) && Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc10_ = ud.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc3_.x * Physics.scale + _loc7_,_loc3_.y * Physics.scale + _loc8_,1,_loc10_,Math.random() * 10 - 5,Math.random() * 10 - 5,1,1);
            _loc9_++;
         }
         if((_loc2_.soft || _loc2_.ignition == 50) && _loc2_.health <= 1)
         {
            if(Math.random() > 0.99)
            {
               if(param1.GetMass() < 0.75)
               {
                  _loc2_.trigger = new Disintegrate("smoke",20,0.1);
                  _loc2_.triggered = true;
               }
               else
               {
                  Main.instance.brittleArray.push(param1);
               }
            }
         }
         _loc4_.draw(_loc5_);
      }
   }
}

