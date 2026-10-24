package
{
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   
   public class StabData
   {
      
      internal var _sharp:b2Body;
      
      internal var _bodypart:b2Body;
      
      internal var joints:Vector.<b2Joint> = new Vector.<b2Joint>();
      
      public function StabData(param1:b2Body, param2:b2Body)
      {
         super();
         this._sharp = param1;
         this._bodypart = param2;
      }
      
      public function exists(param1:b2Body, param2:b2Body) : Boolean
      {
         if(param1 == this._sharp && param2 == this._bodypart)
         {
            return true;
         }
         return false;
      }
      
      public function AddJoint(param1:b2Joint) : void
      {
         this.joints.push(param1);
      }
      
      public function get dead() : Boolean
      {
         if(this.joints.length == 0)
         {
            return true;
         }
         if(!this._sharp || !this._bodypart)
         {
            return true;
         }
         if(userData(this._sharp.GetUserData()).dead)
         {
            return true;
         }
         if(userData(this._bodypart.GetUserData()).dead)
         {
            return true;
         }
         return false;
      }
      
      public function update() : void
      {
         var _loc2_:b2Joint = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:* = int(this.joints.length - 1);
         while(_loc1_ >= 0)
         {
            if(!this.joints[_loc1_] || jointUserData(this.joints[_loc1_].GetUserData()).dead)
            {
               this.joints.splice(_loc1_,1);
            }
            _loc1_--;
         }
         for each(_loc2_ in this.joints)
         {
            _loc3_ = BoxUtils.vectorDist(_loc2_.GetAnchor1(),_loc2_.GetAnchor2());
            _loc4_ = BoxUtils.vectorDist(_loc2_.GetBody1().GetPosition(),_loc2_.GetBody2().GetPosition());
            if(_loc4_ > 100)
            {
               jointUserData(_loc2_.GetUserData()).dead = true;
            }
         }
      }
   }
}

