package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TargetBall extends Trigger
   {
      
      internal var targetBody:b2Body;
      
      internal var coco:int = 0;
      
      public function TargetBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            _loc3_ = new b2Vec2(pixelCenter.x,pixelCenter.y);
            _loc3_.x += (Math.random() * 200 - 100) * param2.size;
            _loc3_.y -= (Math.random() * 400 + 1000) * param2.size;
            _loc4_ = GameState.objects.spawnObject("icicleball",_loc3_.x,_loc3_.y,180,false,true);
            userData(_loc4_.GetUserData()).ignore = "wall";
            userData(_loc4_.GetUserData()).sharp = true;
            _loc5_ = new b2Vec2(0,pixelCenter.y - _loc3_.y);
            _loc5_.Multiply(20);
            _loc4_.ApplyForce(_loc5_,_loc4_.GetWorldCenter());
            ++this.coco;
            if(this.coco == 10)
            {
               param2.dead = true;
            }
         }
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         ud.triggered = true;
      }
   }
}

