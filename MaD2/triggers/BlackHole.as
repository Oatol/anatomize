package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import shiny.PFXVoidInwards;
   import shiny.ParticleEffect;
   
   public class BlackHole extends Trigger
   {
      
      public function BlackHole()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:ParticleEffect = new PFXVoidInwards(param1);
         _loc3_.attachParticles(1,"laser");
         _loc3_.size = 5;
         _loc3_.speed = 1;
         param2.pfx = _loc3_;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         super.trigger(param1,param2);
         var _loc3_:Number = triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,true);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            if(!(_loc6_.name == "portal1" || _loc6_.name == "portal2"))
            {
               if(param2.connected.indexOf(_loc5_) == -1)
               {
                  if(_loc6_.connected.indexOf(param1) == -1)
                  {
                     _loc7_ = bodyCenter.x - _loc5_.GetWorldCenter().x;
                     _loc8_ = bodyCenter.y - _loc5_.GetWorldCenter().y;
                     _loc9_ = _loc7_ * _loc7_ + _loc8_ * _loc8_;
                     _loc5_.ApplyForce(new b2Vec2(-Vars.wind * _loc5_.GetMass() + _loc7_ * triggerForce * 0.2,-Vars.gravity * _loc5_.GetMass() + _loc8_ * triggerForce * 0.2),_loc5_.GetWorldCenter());
                     if(_loc9_ < 8 * userData(param1.GetUserData()).size)
                     {
                        _loc6_.dead = true;
                     }
                  }
               }
            }
         }
      }
   }
}

