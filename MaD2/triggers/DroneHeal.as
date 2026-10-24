package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneHeal extends Drone
   {
      
      public function DroneHeal()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.seek();
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            _loc2_ = userData(_loc1_.GetUserData());
            if(_loc2_.health < _loc2_.maxhealth)
            {
               if(!_loc3_)
               {
                  _loc3_ = _loc1_;
               }
               _loc5_ = userData(_loc3_.GetUserData()).health / userData(_loc3_.GetUserData()).maxhealth;
               _loc6_ = _loc2_.health / _loc2_.maxhealth;
               if(_loc6_ < _loc5_)
               {
                  _loc3_ = _loc1_;
               }
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            followBody(_loc3_);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         if(_loc3_ * _loc3_ + _loc4_ * _loc4_ > 50)
         {
            beginSeek();
            return false;
         }
         _loc5_.health += 20;
         if(_loc5_.bleeding.length > 0 && Math.random() > 0.9)
         {
            _loc5_.bleeding = [];
         }
         if(_loc5_.health >= _loc5_.maxhealth - 2)
         {
            _loc5_.health = _loc5_.maxhealth;
            beginSeek();
            return false;
         }
         var _loc6_:b2Vec2 = bodyCenter;
         var _loc7_:b2Vec2 = targetBody.GetWorldCenter().Copy();
         var _loc8_:Sprite = new Sprite();
         _loc8_.graphics.lineStyle(2,65280,Math.random());
         _loc8_.graphics.moveTo(GraphicUtils.camX(_loc6_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc6_.y * Physics.scale) + camPos.y);
         _loc8_.graphics.lineTo(GraphicUtils.camX(_loc7_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc7_.y * Physics.scale) + camPos.y);
         Main.instance.particlesBMD.draw(_loc8_);
         var _loc9_:String = "heal";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc9_ = ud.pfx.getParticle();
         }
         if(Math.random() > 0.5)
         {
            _loc10_ = Math.random() * _loc5_.width - _loc5_.width * 0.5;
            _loc11_ = Math.random() * _loc5_.height - _loc5_.height * 0.5;
            _loc12_ = targetBody.GetPosition().x * Physics.scale + _loc10_ * Math.cos(targetBody.GetAngle()) - _loc11_ * Math.sin(targetBody.GetAngle());
            _loc13_ = targetBody.GetPosition().y * Physics.scale + _loc10_ * Math.sin(targetBody.GetAngle()) + _loc11_ * Math.cos(targetBody.GetAngle());
            _loc14_ = targetBody.GetLinearVelocity().x * 0.1;
            _loc15_ = targetBody.GetLinearVelocity().y * 0.1;
            GameState.particles.addParticles(_loc12_,_loc13_,1,_loc9_,_loc14_,_loc15_);
         }
         return true;
      }
   }
}

