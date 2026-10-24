package triggers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class AngledGrip extends WeaponMount
   {
      
      public function AngledGrip()
      {
         super();
         hand1 = new b2Vec2(-30 / Physics.scale,-2 / Physics.scale);
         ray1 = new b2Vec2(-32 / Physics.scale,-2 / Physics.scale);
         rayRange = 2;
      }
   }
}

