package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class BuffPotion extends Trigger
   {
      
      internal var bods:Array;
      
      internal var duration:Number;
      
      public function BuffPotion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         this.bods = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         this.duration -= TimeLord.speed;
         if(triggerState == 0)
         {
            param2.graphic.alpha = 0;
            param2.triggerState = 1;
            this.duration = 300;
            param2.ghost = true;
         }
         for each(_loc4_ in this.bods)
         {
            _loc3_ = userData(_loc4_.GetUserData());
            if(this.duration > 0)
            {
               BoxUtils.randomParticlesOnBody(_loc4_,"supershiny",Math.random() * this.duration * 0.05);
            }
            else
            {
               if(_loc3_.alive)
               {
                  _loc3_.dead = true;
               }
               if(_loc3_.name == "doll_head")
               {
                  GameState.objects.buffDoll(_loc4_.GetPosition().x * Physics.scale,_loc4_.GetPosition().y * Physics.scale,_loc4_.GetAngle(),_loc3_.size);
                  param2.dead = true;
               }
            }
         }
         if(this.duration <= 0)
         {
            Body.Destroy(param1,"func");
         }
      }
   }
}

