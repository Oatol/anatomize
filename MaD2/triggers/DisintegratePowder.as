package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DisintegratePowder extends Trigger
   {
      
      private var spread:Number;
      
      private var count:int;
      
      public var sound:Boolean = false;
      
      public function DisintegratePowder(param1:int, param2:Number = 0, param3:Boolean = false)
      {
         super();
         this.spread = param2;
         this.count = param1;
         this.sound = param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.resistDisintegrating)
         {
            param2.trigger.reset();
            param2.triggered = false;
            return;
         }
         if(this.sound)
         {
            sounds.play("tinyhiss",param1,pixelCenter,1);
         }
         var _loc3_:Vector.<b2Body> = Body.Decompose(param1);
         for each(_loc4_ in _loc3_)
         {
            param2.name = BoxUtils.shapeNameToColour(param2.name,param2.skin).toString(16);
            Body.Disintegrate(_loc4_,"inherit",this.count,this.spread,this.spread);
         }
      }
   }
}

