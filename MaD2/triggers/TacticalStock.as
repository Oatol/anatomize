package triggers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class TacticalStock extends WeaponMount
   {
      
      public function TacticalStock()
      {
         super();
         hand1 = new b2Vec2(-26 / Physics.scale,-2 / Physics.scale);
         ray1 = new b2Vec2(-28 / Physics.scale,-2 / Physics.scale);
         rayRange = 2;
      }
   }
}

