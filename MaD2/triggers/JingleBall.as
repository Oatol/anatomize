package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class JingleBall extends Trigger
   {
      
      public function JingleBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(bodyVel.Length() > 10)
         {
            if(Math.random() > 0.85)
            {
               sounds.play("jingle",param1,pixelCenter);
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         super.trigger(body,ud);
         if(!sounds.isPlaying("jingle"))
         {
            sounds.play("jingle",body,pixelCenter);
         }
         return true;
      }
   }
}

