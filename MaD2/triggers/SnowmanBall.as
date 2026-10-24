package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SnowmanBall extends Trigger
   {
      
      public function SnowmanBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         param2.ghost = true;
         var _loc3_:Array = ["snowblock1","snowblock2","snowblock3","carrot","coal","coal","coal","coal","coal","tophat"];
         var _loc4_:Array = [0.5,0.5,0.5,0.5,0.3,0.3,0.3,0.4,0.4,0.6];
         var _loc5_:* = Vars.objSize;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            Vars.objSize = _loc4_[_loc6_] * 1.5 * param2.size;
            _loc7_ = GameState.objects.spawnObject(_loc3_[_loc6_],pixelCenter.x + (Math.random() * 50 - 25) * param2.size,pixelCenter.y + (Math.random() * 50 - 25) * param2.size,Math.random() * 360,false,true);
            _loc7_.SetLinearVelocity(param1.GetLinearVelocity());
            _loc6_++;
         }
         Vars.objSize = _loc5_;
         param2.dead = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggered = true;
         return true;
      }
   }
}

