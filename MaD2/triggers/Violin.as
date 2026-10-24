package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Violin extends PlaySound
   {
      
      public function Violin()
      {
         super("violin",1);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(!sounds.isPlaying("violin"))
         {
            super.trigger(param1,param2);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if((Boolean(_loc7_)) && _loc7_.name == "instrumentalbow")
         {
            ud.triggered = true;
         }
         return true;
      }
   }
}

