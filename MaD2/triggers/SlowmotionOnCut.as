package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SlowmotionOnCut extends Trigger
   {
      
      internal var armour:Armour;
      
      public function SlowmotionOnCut()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.armour = param2.armour;
         if(this.armour)
         {
            this.armour.OnDamage = this.damage;
         }
      }
      
      private function damage(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(param1 < 10)
         {
            return;
         }
         if(!GameState.slomo)
         {
            _loc2_ = 10;
            if(ud.triggerDuration)
            {
               _loc2_ = ud.triggerDuration;
            }
            TimeLord.slowTo(_loc2_);
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
            return true;
         }
         this.damage(param4);
         return true;
      }
      
      override public function OnCutDamage(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnCutDamage(param1,param2);
         if(!ud.triggered)
         {
            return;
         }
         if(!GameState.slomo)
         {
            this.damage(10);
         }
      }
   }
}

