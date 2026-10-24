package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class IndependenceBurger extends Trigger
   {
      
      private var bod:b2Body;
      
      public function IndependenceBurger()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.layer = 2;
         GraphicUtils.addGraphicToLayer(ud);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:Number = NaN;
         super.trigger(param1,param2);
         if(!this.bod)
         {
            return;
         }
         ud.triggerDuration -= TimeLord.speed;
         ud.triggerDuration *= 0.98;
         var _loc3_:b2Vec2 = b2Vec2(this.bod.GetPosition().Copy());
         _loc3_.Multiply(Physics.scale);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"star",Math.random() * 4 - 2,Math.random() * 4 - 2,Math.random() * 10,Math.random() * 10);
         if(ud.triggerDuration <= 0)
         {
            GameState.objects.spawnObject("independenceset",_loc3_.x,_loc3_.y,0,false,true);
            ud.dead = true;
            Body.Disintegrate(body,"star",100,10,10);
         }
         else
         {
            _loc4_ = 60 / ud.triggerDuration;
            if(_loc4_ > 20)
            {
               _loc4_ = 20;
               ud.triggerDuration = 0;
            }
            ud.graphic.scaleX = ud.graphic.scaleY = _loc4_;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if((Boolean(_loc7_)) && _loc7_.name == "doll_head")
         {
            this.bod = param1;
            ud.triggerDuration = 60;
            ud.triggered = true;
            Joints.Weld("weak",body,param1,param1.GetPosition());
         }
         return true;
      }
   }
}

