package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class BallDispenser extends Trigger
   {
      
      private var burnPos:b2Vec2;
      
      internal var gifts:* = ["hexadecagon","hexadecagon","hexadecagon","hexadecagon","hexadecagon","hexadecagon","hexadecagon","hexadecagon","hexadecagon","square","triangle"];
      
      public function BallDispenser()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         this.burnPos = BoxUtils.rotateVec(_loc3_,bodyAngle);
         this.burnPos.Add(pixelCenter);
         param2.triggerDuration -= TimeLord.timerSpeed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            param2.triggered = false;
            this.spawn();
         }
      }
      
      private function spawn() : *
      {
         var _loc7_:b2Body = null;
         var _loc8_:b2Vec2 = null;
         sounds.play("whump",body,pixelCenter,0.5);
         var _loc1_:Vector.<Array> = GameState.objects.spawnSkin;
         var _loc2_:Number = Vars.objSize;
         var _loc3_:Number = Vars.objRestitution;
         Vars.objSize = 0.2;
         Vars.objRestitution = 0.9;
         var _loc4_:Vector.<Array> = new Vector.<Array>();
         var _loc5_:String = ["127beb","da1e1e","0fbf42"][int(Math.random() * 3)];
         var _loc6_:uint = BoxUtils.getSkinColour(ud.skin,_loc5_);
         if(_loc6_ != 16711935)
         {
            _loc5_ = _loc6_.toString(16);
         }
         _loc4_.push(["505050",_loc5_]);
         GameState.objects.spawnSkin = _loc4_;
         _loc7_ = GameState.objects.veryDelayedSpawnObject(this.gifts[int(Math.random() * this.gifts.length)],this.burnPos.x,this.burnPos.y,bodyAngle * Vars.toDegrees,Math.random() > 0.5,true,_loc4_);
         GameState.objects.spawnSkin = _loc1_;
         Vars.objSize = _loc2_;
         Vars.objRestitution = _loc3_;
         if(!_loc7_)
         {
            return;
         }
         userData(_loc7_.GetUserData()).name = "dispensedball";
         userData(_loc7_.GetUserData()).saveable = false;
         userData(_loc7_.GetUserData()).ignored.push(body);
         ud.ignored.push(_loc7_);
         _loc8_ = new b2Vec2(ud.triggerForce,ud.triggerForce);
         _loc8_.Multiply(_loc7_.GetMass() * 10);
         _loc8_.x *= Math.random() - 0.5;
         _loc8_.y *= Math.random() - 0.5;
         var _loc9_:b2Vec2 = BoxUtils.rotateVec(_loc8_,bodyAngle);
         _loc7_.ApplyForce(_loc9_,_loc7_.GetWorldCenter());
      }
   }
}

