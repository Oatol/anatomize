package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneChild extends Drone
   {
      
      public var mother:b2Body;
      
      public function DroneChild()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.seek();
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            _loc2_ = ["dronebuilder","dronebullet","dronemelee","droneexplosive","dronehammer","droneheal","dronejanitor","droneking","dronelaser","dronepaint","dronepin","dronerocket","droneshield","droneclean","dronetoxic","dronetracker","droneon","droneoff"];
            _loc3_ = _loc2_[int(Math.random() * _loc2_.length)];
            ud.trigger = new Transmute(_loc3_);
            this.OnDelete();
         }
         if(!this.mother)
         {
            return;
         }
         _loc1_ = new b2Vec2();
         _loc1_.x = this.mother.GetPosition().x - bodyCenter.x + Math.random() * 50 - 25;
         _loc1_.y = this.mother.GetPosition().y - bodyCenter.y + Math.random() * 50 - 25;
         _loc1_.Multiply(body.GetMass());
         body.ApplyForce(_loc1_,bodyCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.trigger is Drone)
         {
            return false;
         }
         if(Boolean(_loc7_) && _loc7_.name == "dronechild")
         {
            return false;
         }
         ud.trigger = new Disintegrate("warning",3,3);
         if(!this.mother)
         {
            return false;
         }
         var _loc8_:userData = userData(this.mother.GetUserData());
         if((Boolean(_loc8_)) && _loc8_.trigger is DroneMother)
         {
            DroneMother(_loc8_.trigger).Aggro(param1);
         }
         return true;
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         if(!this.mother)
         {
            return;
         }
         var _loc1_:userData = userData(this.mother.GetUserData());
         if(Boolean(_loc1_) && _loc1_.trigger is DroneMother)
         {
            DroneMother(_loc1_.trigger).RIP();
         }
      }
   }
}

