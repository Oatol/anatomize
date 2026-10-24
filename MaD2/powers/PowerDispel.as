package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerDispel extends Power
   {
      
      public function PowerDispel()
      {
         super(Tool.DISPEL,"light","lig");
         throwSound = "dispel";
         bodySound = "dispel";
         throwVol = 0.3;
         bodyVol = 0.2;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Dispel(param1);
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:Number = Math.random();
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * _loc3_,particleAngle);
         var _loc5_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * _loc3_ * 0.8,particleAngle);
         var _loc6_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * _loc3_,particleAngle + (Math.random() > 0.5 ? -20 : 20));
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,"light",param2.x * 0.1 + _loc4_.x - _loc5_.x,param2.y * 0.1 + _loc4_.y - _loc5_.y,0,0);
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,"light",param2.x * 0.1 + (_loc6_.x - _loc4_.x) * 0.1,param2.y * 0.1 + (_loc6_.y - _loc4_.y) * 0.1,0,0);
         var _loc7_:Number = Tweak.toolRadius * 2;
         Shadows.lightPos = param1.Copy();
         Shadows.lightRadius = _loc7_;
         Main.instance.drawShadowsFor(Body.GetMultiple(new b2Vec2((param1.x - _loc7_) / Physics.scale,(param1.y - _loc7_) / Physics.scale),_loc7_ * 2 / Physics.scale,_loc7_ * 2 / Physics.scale),1);
      }
   }
}

