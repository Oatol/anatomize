package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class MagicNail extends Trigger
   {
      
      private var targetBody:b2Body;
      
      public function MagicNail()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:String = null;
         super.trigger(param1,param2);
         if(!this.targetBody)
         {
            return;
         }
         var _loc3_:b2Vec2 = this.targetBody.GetWorldCenter().Copy();
         _loc3_.Multiply(Physics.scale);
         var _loc4_:Number = this.targetBody.GetAngle() * Vars.toDegrees;
         var _loc5_:userData = userData(this.targetBody.GetUserData());
         var _loc7_:b2Body = GameState.objects.spawnObject("deadset",_loc3_.x,_loc3_.y,_loc4_,_loc5_.flipped,true);
         sounds.random(["cut1","cut2","cut3","cut4","cut5","cut6"],body,pixelCenter);
         sounds.random(["cut1","cut2","cut3","cut4","cut5","cut6"],body,pixelCenter);
         ud.dead = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sticky)
         {
            return false;
         }
         var _loc7_:Array = BoxUtils.selectCompound(param1);
         var _loc8_:userData = userData(param1.GetUserData());
         if(_loc8_.name.indexOf("doll_") != -1)
         {
            this.targetBody = param1;
            ud.triggered = true;
         }
         return true;
      }
   }
}

