package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Broomstick extends Trigger
   {
      
      public function Broomstick()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggered)
         {
            if(param3.name == "734528" || param3.name == "800000")
            {
               GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,"dusty",0,0,2,2);
            }
         }
         return true;
      }
   }
}

