package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Chainsaw extends CutOnCollision
   {
      
      internal var wroom:int = 0;
      
      public function Chainsaw()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!sounds.isPlaying("chainsaw_idle"))
         {
            sounds.play("chainsaw_idle",body,body.GetWorldCenter(),0.5,false,1);
         }
         --this.wroom;
      }
      
      override public function onUntrigger() : void
      {
         sounds.stop("chainsaw_idle");
         sounds.stop("chainsaw_cut");
         super.onUntrigger();
      }
      
      override public function OnDelete() : void
      {
         sounds.stop("chainsaw_idle");
         sounds.stop("chainsaw_cut");
         super.OnDelete();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            ++this.wroom;
            sounds.stop("chainsaw_idle");
            sounds.play("chainsaw_cut",body,body.GetWorldCenter(),Math.min(0.4,this.wroom * 0.05),true);
            return true;
         }
         return false;
      }
   }
}

