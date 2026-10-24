package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TargetArrow extends Trigger
   {
      
      internal var targetBody:b2Body;
      
      internal var coco:int = 0;
      
      public function TargetArrow()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         BoxUtils.randomParticlesOnBody(param1,"fire2",0);
         if(param2.triggerDuration <= 0 && Math.random() > 0.9)
         {
            _loc3_ = param2.triggerPos.Copy();
            _loc3_.x += (Math.random() * 120 - 60) * param2.size;
            _loc3_.y -= (Math.random() * 400 + 1000) * param2.size;
            _loc4_ = GameState.objects.spawnObject("arrowproj",_loc3_.x,_loc3_.y,-90 + Math.random() * 30 - 15,false,true);
            userData(_loc4_.GetUserData()).ignore = "wall";
            userData(_loc4_.GetUserData()).trigger = new Arrow();
            _loc5_ = new b2Vec2(0,pixelCenter.y - _loc3_.y);
            _loc5_.Multiply(20);
            _loc4_.ApplyForce(_loc5_,_loc4_.GetWorldCenter());
            ++this.coco;
            if(this.coco == 10)
            {
               param2.dead = true;
               Body.Disintegrate(param1,"fire3",20);
            }
         }
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         if(param1.IsStatic())
         {
            return;
         }
         ud.triggered = true;
         ud.triggerDuration = Math.random() * 120 + 60;
         ud.triggerPos = param1.GetPosition().Copy();
         ud.triggerPos.Multiply(Physics.scale);
         ud.ghost = true;
      }
   }
}

