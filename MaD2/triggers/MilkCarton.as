package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MilkCarton extends Trigger
   {
      
      public function MilkCarton()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:String = null;
         var _loc7_:userData = null;
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.8)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = BoxUtils.rotateVec(new b2Vec2(param2.size * -10,param2.size * -20),bodyAngle);
               _loc5_ = param2.skin;
               _loc6_ = "EEEEEE";
               _loc7_ = Properties.objTemp(_loc6_);
               _loc7_.trigger = new Juice();
               _loc7_.triggered = true;
               _loc7_.projectileName = "pnt";
               _loc8_ = Spawn.circle(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y,0.1,_loc7_,[1,1,1]);
               _loc8_.ApplyForce(new b2Vec2(bodyVel.x * 0.001,bodyVel.y * 0.001),_loc8_.GetWorldCenter());
            }
         }
      }
   }
}

