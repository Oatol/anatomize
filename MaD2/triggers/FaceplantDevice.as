package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FaceplantDevice extends Trigger
   {
      
      public function FaceplantDevice()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Body = null;
         var _loc8_:userData = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         var _loc3_:String = "blood";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:Array = Body.GetAround(param1,triggerRadius * param2.size,triggerRadius * param2.size);
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         for each(_loc7_ in _loc4_)
         {
            _loc8_ = userData(_loc7_.GetUserData());
            if(_loc8_.name == "doll_head")
            {
               _loc6_ = true;
               break;
            }
         }
         if(!_loc6_)
         {
            return;
         }
         for each(_loc7_ in _loc4_)
         {
            _loc7_.WakeUp();
            _loc5_ = bodyCenter.x - _loc7_.GetWorldCenter().x;
            _loc8_ = userData(_loc7_.GetUserData());
            if(_loc8_.alive)
            {
               if(_loc8_.name == "doll_head")
               {
                  _loc7_.ApplyTorque(0.1 * param2.triggerForce * _loc7_.GetMass() * (_loc5_ > 0 ? -1 : 1));
                  _loc7_.ApplyImpulse(new b2Vec2(0,param2.triggerForce * _loc7_.GetMass()),_loc7_.GetWorldCenter());
                  _loc7_.WakeUp();
               }
               else
               {
                  _loc7_.GetLinearVelocity().Multiply(0.8);
               }
            }
         }
         if(Math.random() > 0.9)
         {
            _loc9_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 40 - 10);
            _loc10_ = BoxUtils.rotateVec(_loc9_,bodyAngle);
            _loc11_ = GameState.particles.addParticles(pixelCenter.x + _loc10_.x * param2.size,pixelCenter.y + _loc10_.y * param2.size,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1 + Math.random() * 10,0,0);
            if((Boolean(_loc11_)) && Boolean(_loc11_[0]))
            {
               _loc11_[0].health = 100;
               _loc11_[0].friction = 0.9;
            }
         }
      }
   }
}

