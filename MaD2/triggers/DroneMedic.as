package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneMedic extends Drone
   {
      
      internal var replacing:Boolean = false;
      
      public function DroneMedic()
      {
         super();
         ignoreTinyStuff = false;
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc4_:int = 0;
         super.seek();
         if(ud.triggerState != 1)
         {
            _loc4_ = 0;
            while(_loc4_ < seekbodies.length)
            {
               _loc1_ = b2Body(seekbodies[_loc4_]);
               _loc2_ = userData(_loc1_.GetUserData());
               if(_loc2_.hasBeenCut)
               {
                  _loc3_ = _loc1_;
                  followBody(_loc3_);
                  this.replacing = true;
                  return;
               }
               _loc4_++;
            }
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            _loc2_ = userData(_loc1_.GetUserData());
            if(_loc2_.alive && Math.random() > 0.8)
            {
               _loc3_ = _loc1_;
               followBody(_loc3_);
               this.replacing = false;
               break;
            }
            _loc4_++;
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         if(_loc3_ * _loc3_ + _loc4_ * _loc4_ > 50)
         {
            beginSeek();
            return false;
         }
         if(this.replacing)
         {
            this.FixBrokenItem();
         }
         else if(Body.GrowMissingBodypart(targetBody))
         {
            this.Effect();
         }
         beginSeek();
         return true;
      }
      
      internal function Effect() : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:userData = userData(targetBody.GetUserData());
         var _loc2_:b2Vec2 = bodyCenter;
         var _loc3_:b2Vec2 = targetBody.GetWorldCenter().Copy();
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.lineStyle(2,65280,Math.random());
         _loc4_.graphics.moveTo(GraphicUtils.camX(_loc2_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc2_.y * Physics.scale) + camPos.y);
         _loc4_.graphics.lineTo(GraphicUtils.camX(_loc3_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc3_.y * Physics.scale) + camPos.y);
         Main.instance.particlesBMD.draw(_loc4_);
         var _loc5_:String = "heal";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc5_ = ud.pfx.getParticle();
         }
         if(Math.random() > 0.5)
         {
            _loc6_ = Math.random() * _loc1_.width - _loc1_.width * 0.5;
            _loc7_ = Math.random() * _loc1_.height - _loc1_.height * 0.5;
            _loc8_ = targetBody.GetPosition().x * Physics.scale + _loc6_ * Math.cos(targetBody.GetAngle()) - _loc7_ * Math.sin(targetBody.GetAngle());
            _loc9_ = targetBody.GetPosition().y * Physics.scale + _loc6_ * Math.sin(targetBody.GetAngle()) + _loc7_ * Math.cos(targetBody.GetAngle());
            _loc10_ = targetBody.GetLinearVelocity().x * 0.1;
            _loc11_ = targetBody.GetLinearVelocity().y * 0.1;
            GameState.particles.addParticles(_loc8_,_loc9_,1,_loc5_,_loc10_,_loc11_);
         }
      }
      
      private function FixBrokenItem() : void
      {
         this.Effect();
         Body.FixBrokenItem(targetBody);
      }
   }
}

