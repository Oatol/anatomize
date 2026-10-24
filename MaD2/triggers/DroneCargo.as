package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneCargo extends Drone
   {
      
      private var flytarget:int = -1;
      
      public function DroneCargo()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration > 0)
         {
            return;
         }
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(!_loc1_.IsStatic())
            {
               followBody(_loc1_);
               state = "destroy";
               break;
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Sprite = null;
         super.follow();
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = new Sprite();
            _loc3_.graphics.lineStyle(2,11184810,Math.random());
            _loc3_.graphics.moveTo(_loc1_.x * Physics.scale + camPos.x,_loc1_.y * Physics.scale + camPos.y);
            _loc3_.graphics.lineTo(_loc2_.x * Physics.scale + camPos.x,_loc2_.y * Physics.scale + camPos.y);
            Main.instance.particlesBMD.draw(_loc3_);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc14_:Number = NaN;
         if(!super.destroy())
         {
            return false;
         }
         if(BoxUtils.vectorDist(bodyCenter,targetBody.GetWorldCenter()) > 60)
         {
            beginSeek();
            return false;
         }
         if(this.flytarget == -1)
         {
            this.flytarget = GameState.environment.borderLeft + 50 + Math.random() * (GameState.environment.borderRight - 100);
         }
         if(ud.connected.length > 0)
         {
            this.flytarget = ud.connected[0].GetWorldCenter().x * Physics.scale;
         }
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
         var _loc1_:b2Vec2 = ud.triggerPos.Copy();
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(_loc1_,bodyAngle);
         var _loc3_:Number = 50 * ud.size;
         var _loc4_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc2_.x,pixelCenter.y + _loc2_.y);
         var _loc5_:Array = Body.GetAroundPoint(_loc4_,_loc3_,_loc3_,false);
         var _loc6_:String = "forcefield";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc6_ = ud.pfx.getParticle();
         }
         var _loc7_:b2Body = targetBody;
         _loc7_.WakeUp();
         var _loc8_:b2Vec2 = new b2Vec2(-_loc7_.GetWorldCenter().x * Physics.scale + _loc4_.x,-_loc7_.GetWorldCenter().y * Physics.scale + _loc4_.y);
         var _loc9_:Number = _loc8_.Normalize();
         var _loc10_:Number = 10 * ud.triggerForce / ((_loc3_ - _loc9_) / _loc3_) * ud.size;
         var _loc11_:b2Vec2 = _loc7_.GetWorldCenter().Copy();
         _loc11_.Multiply(Physics.scale);
         BoxUtils.randomParticlesOnBody(_loc7_,_loc6_);
         var _loc12_:b2Vec2 = new b2Vec2(_loc8_.x * _loc10_,_loc8_.y * _loc10_);
         _loc7_.GetLinearVelocity().Multiply(0.9);
         _loc7_.SetAngularVelocity(_loc7_.GetAngularVelocity() * 0.9);
         _loc7_.ApplyForce(_loc12_,_loc7_.GetWorldCenter());
         ud.triggerDuration -= TimeLord.speed;
         var _loc13_:Number = -pixelCenter.x + this.flytarget;
         if(Math.abs(_loc13_) < 50)
         {
            body.GetLinearVelocity().Multiply(0.99);
            if(Math.abs(bodyVel.x) < 0.2)
            {
               beginSeek();
               this.flytarget = -1;
            }
         }
         else
         {
            _loc14_ = 0;
            if(pixelCenter.y > 400)
            {
               _loc14_ = -10;
            }
            fly(_loc13_ * 0.2,_loc14_,0);
         }
         return true;
      }
   }
}

