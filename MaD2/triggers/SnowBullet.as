package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class SnowBullet extends GenericBullet
   {
      
      internal var bloopa:int = 10;
      
      public function SnowBullet()
      {
         super("crystal");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         var _loc5_:* = 0;
         super.trigger(param1,param2);
         GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"gas",0,0,1,1);
         if(!param1.m_jointList)
         {
            return;
         }
         --this.bloopa;
         if(this.bloopa == 0)
         {
            this.bloopa = 10;
            _loc3_ = param1.m_jointList.other;
            _loc4_ = userData(_loc3_.GetUserData());
            if(_loc3_.IsStatic())
            {
               this.safeExplode();
               return;
            }
            if(Boolean(_loc3_) && _loc3_ != param1)
            {
               _loc4_.temperature -= 50;
               if(_loc4_.temperature <= 0)
               {
                  Body.Freeze(_loc3_,-100);
                  _loc5_ = 20;
                  if(!userData(_loc3_.GetUserData()).unbreakable)
                  {
                     while(_loc5_ > 0 && userData(_loc3_.GetUserData()).name != "dead")
                     {
                        _loc5_--;
                        Body.brittle(_loc3_);
                     }
                  }
                  this.safeExplode();
               }
               Body.Damage(_loc3_,12,_loc3_.GetPosition().Copy(),null,null,false);
            }
         }
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"crystal",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"gas",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
            _loc1_++;
         }
         Body.Destroy(body,"trigger");
      }
   }
}

