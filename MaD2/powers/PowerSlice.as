package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerSlice extends Power
   {
      
      public function PowerSlice()
      {
         super(Tool.SLICE,"slice","sli");
         throwSound = "throw3";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         super.OnBodyPress(param1);
         if(Math.random() < 0.9)
         {
            return;
         }
         var _loc5_:Number = Tweak.toolRadius;
         _loc4_ = Math.random() * Math.random() * 60 + 20;
         _loc2_ = new b2Vec2(bodyPos.x * Physics.scale + Math.random() * _loc5_ - _loc5_ * 0.5,bodyPos.y * Physics.scale + Math.random() * _loc5_ - _loc5_ * 0.5);
         _loc3_ = new b2Vec2(bodyPos.x * Physics.scale + Math.random() * _loc5_ - _loc5_ * 0.5,bodyPos.y * Physics.scale + Math.random() * _loc5_ - _loc5_ * 0.5);
         GameState.madeby = "rendgrenade";
         GameState.cutter.IncludeSingle(param1);
         GameState.cutter.CustomCut(_loc2_,_loc3_,1,_loc4_,360);
         Physics.contactFilter.cutInclude = new Vector.<b2Body>();
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,Math.random() * 360);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,particle,param2.x * 0.1 + (_loc4_.x - _loc3_.x) * 0.3,param2.y * 0.1 + (_loc4_.y - _loc3_.y) * 0.3,0,0);
      }
   }
}

