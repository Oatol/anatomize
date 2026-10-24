package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Briefcase extends Trigger
   {
      
      internal var value:String;
      
      public function Briefcase()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(triggerState == 1 && Boolean(this.value))
         {
            this.spawn();
            this.value = null;
            ud.triggered = false;
            ud.triggerState = 0;
         }
      }
      
      override public function OnLoadCustom() : void
      {
         if(ud.triggerCustom)
         {
            this.value = ud.triggerCustom;
            ud.triggerState = 1;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return false;
         }
         if(this.value)
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || _loc7_.dead)
         {
            return false;
         }
         _loc7_.dead = true;
         this.value = _loc7_.name;
         ud.triggerCustom = this.value;
         ud.triggered = false;
         ud.triggerState = 1;
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         super.trigger(body,ud);
         if(!this.value)
         {
            return false;
         }
         ud.triggerPos = new b2Vec2();
         this.spawn();
         this.value = null;
         ud.triggerCustom = this.value;
         return false;
      }
      
      private function spawn() : void
      {
         var _loc1_:b2Vec2 = ud.triggerPos.Copy();
         if(ud.flipped)
         {
            _loc1_.x *= -1;
         }
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(_loc1_,bodyAngle);
         var _loc3_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc2_.x,pixelCenter.y + _loc2_.y);
         var _loc4_:b2Body = GameState.objects.spawnObject(this.value,_loc3_.x,_loc3_.y,0,false,true);
      }
   }
}

