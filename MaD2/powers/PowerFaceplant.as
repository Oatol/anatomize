package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerFaceplant extends Power
   {
      
      public function PowerFaceplant()
      {
         super(Tool.FACEPLANT,"gravity","faceplant");
         noThrow = true;
         noEffectForce = false;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Body = null;
         bodies = Body.GetAroundPoint(new b2Vec2(param1.x,param1.y),Tweak.toolRadius,Tweak.toolRadius,false);
         pressPos = param1;
         for each(_loc3_ in bodies)
         {
            Body.Faceplant(_loc3_,param1,Tweak.toolEffectForce * 10);
         }
      }
   }
}

