package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class WallBouncer extends Trampoline
   {
      
      private var decals:Sprite;
      
      internal var busy:Boolean = false;
      
      public function WallBouncer()
      {
         super();
      }
      
      private function animate() : void
      {
         if(!this.decals)
         {
            this.decals = ud.graphic.getChildByName("decals") as Sprite;
         }
         if(ud.triggerForce < 50)
         {
            ud.triggerForce = 50;
         }
         var _loc1_:Number = -15;
         var _loc2_:Number = ud.triggerForce * 0.001 / TimeLord.speed;
         Tweener.addTween(this.decals,{
            "y":_loc1_,
            "time":_loc2_,
            "transition":"easeOutElastic"
         });
         Tweener.addTween(this.decals,{
            "y":0,
            "delay":_loc2_,
            "time":_loc2_,
            "transition":"easeOutBounce",
            "onComplete":this.finished
         });
         this.busy = true;
      }
      
      private function finished() : void
      {
         this.busy = false;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(this.busy)
         {
            return true;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         super.OnCollision(param1,param2,param3,param4,param5,param6);
         this.animate();
         return false;
      }
   }
}

