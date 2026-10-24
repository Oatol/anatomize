package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class OilBarrel extends Trigger
   {
      
      public function OilBarrel()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.7)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = -1;
               if(param2.flipped)
               {
                  _loc4_ = 1;
               }
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(param2.size * _loc4_ * 30,param2.size * -68),bodyAngle);
               this.Spill(_loc5_);
            }
         }
      }
      
      private function Spill(param1:b2Vec2) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc2_:Vector.<Array> = ud.skin;
         var _loc3_:userData = Properties.objBurn("gasoline");
         _loc3_.saveable = false;
         _loc3_.trigger = new Oil();
         _loc3_.triggered = true;
         _loc3_.temperature = 30;
         _loc3_.ignition = 40;
         _loc3_.ignore = "oilbarrel";
         _loc3_.ignored.push(body);
         var _loc4_:Array = Body.GetAround(body,20,20,false);
         for each(_loc5_ in _loc4_)
         {
            if(userData(_loc5_.GetUserData()).burning)
            {
               _loc3_.ignition = _loc3_.temperature;
            }
         }
         _loc6_ = Spawn.circle(-500,-500,0.1,_loc3_,[1,1,1]);
         _loc6_.SetXForm(new b2Vec2((pixelCenter.x + param1.x) / Physics.scale,(pixelCenter.y + param1.y) / Physics.scale),_loc6_.GetAngle());
         _loc7_ = new b2Vec2(bodyVel.x * 0.005,bodyVel.y * 0.005);
         _loc8_ = new b2Vec2(bodyCenter.x - _loc6_.GetPosition().x,bodyCenter.y - _loc6_.GetPosition().y);
         _loc8_.Add(new b2Vec2(Math.random() * 4 - 2,Math.random() * 4 - 2));
         _loc8_.Multiply(-0.005);
         _loc7_.Add(_loc8_);
         _loc6_.ApplyForce(_loc7_,_loc6_.GetWorldCenter());
      }
      
      override public function OnCut() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < Math.random() * 20 + 5)
         {
            this.Spill(new b2Vec2(Math.random() * 40 - 20,Math.random() * 40 - 20));
            _loc1_++;
         }
         return false;
      }
   }
}

