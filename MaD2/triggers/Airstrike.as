package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Airstrike extends Trigger
   {
      
      internal var targetBody:b2Body;
      
      internal var coco:int = 0;
      
      public function Airstrike()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:String = null;
         var _loc5_:b2Body = null;
         var _loc6_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         BoxUtils.randomParticlesOnBody(param1,"fire2",0);
         if(param2.triggerDuration <= 0 && Math.random() > 0.9)
         {
            param2.triggerDuration = Math.random() * param2.originalTriggerDuration;
            _loc3_ = pixelCenter.Copy();
            _loc3_.x += (Math.random() * 120 - 60) * param2.size;
            _loc3_.y -= (Math.random() * 400 + 1000) * param2.size;
            _loc4_ = "airbomb";
            if(param2.triggerCustom)
            {
               _loc4_ = param2.triggerCustom;
            }
            if(param2.connected.length > 0)
            {
               _loc4_ = userData(param2.connected[Math.random() * param2.connected.length >> 0].GetUserData()).name;
            }
            _loc5_ = GameState.objects.spawnObject(_loc4_,_loc3_.x,_loc3_.y,Math.random() * 360 - 180,false,true);
            if(!_loc5_)
            {
               _loc5_ = GameState.objects.spawnObject("airbomb",_loc3_.x,_loc3_.y,-180 + Math.random() * 30 - 15,false,true);
            }
            userData(_loc5_.GetUserData()).ignore = "wall";
            userData(_loc5_.GetUserData()).triggerOnContact = true;
            _loc6_ = new b2Vec2(0,pixelCenter.y - _loc3_.y);
            _loc6_.Multiply(20);
            _loc5_.ApplyForce(_loc6_,_loc5_.GetWorldCenter());
            ++this.coco;
            if(this.coco >= param2.triggerForce)
            {
               param2.dead = true;
               Body.Disintegrate(param1,"fire3",20);
            }
         }
      }
   }
}

