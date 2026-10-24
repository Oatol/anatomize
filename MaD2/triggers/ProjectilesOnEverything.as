package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ProjectilesOnEverything extends ProjectilesWhenSpunOrSwung
   {
      
      public function ProjectilesOnEverything()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(param4 > ud.triggerForce)
         {
            spawn = true;
         }
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(param2 > ud.triggerForce)
         {
            spawn = true;
         }
      }
   }
}

