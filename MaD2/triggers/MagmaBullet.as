package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class MagmaBullet extends GenericBullet
   {
      
      internal var stuck:Boolean = false;
      
      public function MagmaBullet()
      {
         super("fire2");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:userData = null;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         particle = ["fire2","fire3","explosive","smoke"][Math.random() * 4 >> 0];
         if(param2.temperature < 50)
         {
            this.safeExplode();
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"smoke",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.1,bodyVel.y * 0.1);
            return;
         }
         GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,particle,bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.1,bodyVel.y * 0.1);
         if(!this.stuck)
         {
            return;
         }
         var _loc3_:Array = Body.GetMultiple(bodyCenter,triggerRadius / Physics.scale,triggerRadius / Physics.scale,false);
         var _loc4_:Array = [];
         var _loc5_:Array = ["dragonsbreath","magma"];
         for each(_loc7_ in _loc3_)
         {
            _loc6_ = userData(_loc7_.GetUserData());
            if((Boolean(_loc6_)) && _loc5_.indexOf(_loc6_.name) == -1)
            {
               _loc4_.push(_loc7_);
            }
         }
         if(_loc4_.length <= 1)
         {
            if(this.stuck && Math.random() > 0.99)
            {
               this.safeExplode();
            }
            return;
         }
         var _loc8_:b2Body = _loc4_[Math.random() * _loc4_.length >> 0];
         _loc6_ = userData(_loc8_.GetUserData());
         if(_loc8_.IsStatic() && Math.random() > 0.95)
         {
            this.safeExplode();
            return;
         }
         if(Boolean(_loc8_) && _loc8_ != param1)
         {
            if(Math.random() > 0.95)
            {
               _loc6_.temperature += 50;
               this.safeExplode();
            }
            this.char(_loc8_);
            Body.Damage(_loc8_,36,_loc8_.GetPosition().Copy(),null,null,false);
         }
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         this.stuck = true;
         var _loc2_:userData = userData(param1.GetUserData());
         _loc2_.temperature += 50;
         if(_loc2_.alive)
         {
            Body.Damage(param1,36,param1.GetPosition().Copy(),null,null,false);
         }
      }
      
      private function char(param1:b2Body) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:String = null;
         if(World.toggleGore == 0)
         {
            return;
         }
         var _loc2_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         var _loc4_:Sprite = new Sprite();
         var _loc5_:int = Math.random() * 12 + 3;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            if(Math.random() > 0.3)
            {
               _loc4_.graphics.beginFill(2236962,Math.random());
            }
            else
            {
               _loc4_.graphics.beginFill(_loc3_.bloodColour,Math.random());
            }
            _loc6_ = -10 + Math.random() * (userData(param1.GetUserData()).width + 20);
            _loc7_ = -10 + Math.random() * (userData(param1.GetUserData()).height + 20);
            _loc4_.graphics.drawCircle(_loc6_,_loc7_,Math.random() * 5);
            _loc4_.graphics.endFill();
            _loc9_ = ["fire2","fire3","smoke"][Math.random() * 3 >> 0];
            GameState.particles.addParticles(param1.GetPosition().x * Physics.scale + _loc6_,param1.GetPosition().y * Physics.scale + _loc7_,1,_loc9_,Math.random() * 10 - 5,Math.random() * 10 - 5,1,1);
            _loc8_++;
         }
         _loc2_.draw(_loc4_);
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"fire2",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"fire3",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
            _loc1_++;
         }
         Body.Destroy(body,"trigger");
      }
   }
}

