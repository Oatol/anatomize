package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Cursed extends Trigger
   {
      
      internal var cursedItem:b2Body;
      
      public function Cursed(param1:b2Body)
      {
         super();
         temporary = true;
         this.cursedItem = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            param2.health -= Math.random() * 4 + 2;
            if(param2.health <= param2.maxhealth * 0.2 && Math.random() > 0.99)
            {
               if(this.cursedItem)
               {
                  Body.RemoveJointsNextFrame(this.cursedItem);
                  userData(this.cursedItem.GetUserData()).triggerLock = false;
                  userData(this.cursedItem.GetUserData()).triggered = true;
                  _loc4_ = this.cursedItem.GetWorldCenter().Copy();
                  _loc4_.Subtract(bodyCenter);
                  _loc4_.Multiply(10 * this.cursedItem.GetMass());
                  this.cursedItem.ApplyImpulse(_loc4_,this.cursedItem.GetWorldCenter());
               }
               param2.trigger.reset();
               _loc3_ = 0;
               while(_loc3_ < 20)
               {
                  this.Effect();
                  _loc3_++;
               }
               return;
            }
            if(Math.random() > 0.95)
            {
               this.Effect();
            }
         }
      }
      
      private function Effect() : void
      {
         var _loc2_:MyLittleParticle = null;
         var _loc1_:Vector.<MyLittleParticle> = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"stoneskull",0,0,Math.random() * 2,Math.random() * 2);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.friction = 0.5;
            _loc2_.wander = 2;
         }
      }
   }
}

