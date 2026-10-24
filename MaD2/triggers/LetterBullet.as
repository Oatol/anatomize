package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class LetterBullet extends GraphicsVariance
   {
      
      internal var bod:b2Body;
      
      public function LetterBullet()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerState != 1)
         {
            return;
         }
         var _loc3_:Array = customs["effects"].split(",");
         if(_loc3_.length < randoms[0])
         {
            param2.dead = true;
            return;
         }
         Body.ApplyEffect(this.bod,_loc3_[randoms[0]],pixelCenter,param1);
         if(Math.random() > 0.98)
         {
            param2.dead = true;
         }
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         this.bod = param1;
         ud.triggerState = 1;
         ud.triggered = true;
      }
   }
}

