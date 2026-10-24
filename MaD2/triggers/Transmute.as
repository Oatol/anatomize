package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Transmute extends Trigger
   {
      
      protected var item:*;
      
      public function Transmute(param1:String = "none")
      {
         super();
         if(param1 != "none")
         {
            this.item = param1;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.resistTransmuting)
         {
            param2.trigger.reset();
            return;
         }
         if(!this.item)
         {
            this.item = O.names[int(Math.random() * O.names.length)];
         }
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(param2.triggerPos,bodyAngle);
         _loc3_.Add(pixelCenter);
         var _loc4_:b2Body = GameState.objects.spawnObject(this.item,_loc3_.x,_loc3_.y,bodyAngle * Vars.toDegrees,param2.flipped,true);
         if(_loc4_)
         {
            _loc4_.SetLinearVelocity(param1.GetLinearVelocity());
            _loc4_.SetAngularVelocity(param1.GetAngularVelocity());
         }
         param2.dead = true;
      }
   }
}

