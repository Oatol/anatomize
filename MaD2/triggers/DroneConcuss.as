package triggers
{
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class DroneConcuss extends Drone
   {
      
      internal var offset:Sprite;
      
      internal var hammer:Sprite;
      
      internal var busy:Boolean = false;
      
      public function DroneConcuss()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.offset = new Sprite();
         this.hammer = O.getItem("rubberhammer").updateGraphic();
         this.offset.addChild(this.hammer);
         this.hammer.y = -60;
         this.hammer.x = 0;
         this.hammer.scaleX = this.hammer.scaleY = 1.5;
         this.offset.scaleX = this.offset.scaleY = 0;
         ud.graphic.addChildAt(this.offset,0);
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(userData(_loc1_.GetUserData()).saveable != false)
            {
               if(userData(_loc1_.GetUserData()).alive)
               {
                  if(_loc1_.GetMass() >= 0.1)
                  {
                     if(Math.random() > 0.8)
                     {
                        followBody(_loc1_);
                        break;
                     }
                  }
               }
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         super.follow();
         if(!this.busy)
         {
            this.animate();
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         return true;
      }
      
      internal function animate() : void
      {
         this.busy = true;
         this.hammer.visible = true;
         var _loc1_:Number = Math.atan2(bodyCenter.y - targetBody.GetPosition().y,bodyCenter.x - targetBody.GetPosition().x);
         _loc1_ *= Vars.toDegrees;
         _loc1_ -= 90;
         _loc1_ += Math.random() * 20 - 10;
         _loc1_ -= ud.graphic.rotation;
         var _loc2_:Number = 1 + Math.random();
         Tweener.addTween(this.offset,{
            "scaleX":_loc2_,
            "scaleY":_loc2_,
            "rotation":_loc1_,
            "delay":0.2 + Math.random() * 0.6,
            "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.finished
         });
      }
      
      internal function mash() : *
      {
      }
      
      internal function finished() : void
      {
         var _loc3_:int = 0;
         if(targetBody)
         {
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               BoxUtils.randomParticlesOnBody(targetBody,"star");
               _loc3_++;
            }
            Body.Concuss(targetBody,10);
         }
         var _loc1_:Number = Math.random() * 360;
         var _loc2_:Number = 0.1;
         Tweener.addTween(this.offset,{
            "scaleX":_loc2_,
            "scaleY":_loc2_,
            "rotation":_loc1_,
            "delay":0.2,
            "time":(0.2 + Math.random() * 0.2) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.rewind
         });
      }
      
      internal function rewind() : void
      {
         this.busy = false;
         beginSeek();
      }
   }
}

