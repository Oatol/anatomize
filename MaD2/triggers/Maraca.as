package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Maraca extends Trigger
   {
      
      internal var vels:Vector.<Number> = new Vector.<Number>();
      
      public function Maraca()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         super.trigger(param1,param2);
         this.vels.push(bodyVel.Length());
         if(this.vels.length > 5)
         {
            this.vels.shift();
            _loc3_ = 0;
            _loc4_ = int(this.vels.length - 1);
            while(_loc4_ > 0)
            {
               if(Math.abs(this.vels[_loc4_] - this.vels[4]) > 5)
               {
                  _loc3_++;
               }
               _loc4_--;
            }
            if(_loc3_ > 2)
            {
               this.tssk();
               this.vels = new Vector.<Number>();
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!sounds.isPlaying("maraca1") && !sounds.isPlaying("maraca2") && !sounds.isPlaying("maraca3"))
         {
            this.tssk();
         }
         return true;
      }
      
      internal function tssk() : *
      {
         sounds.random(["maraca1","maraca2","maraca3"],body,pixelCenter);
      }
   }
}

