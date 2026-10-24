package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   
   public class Grapple extends Trigger
   {
      
      private var grappler:b2Body;
      
      private var grappled:b2Body;
      
      public var grapplered:Boolean;
      
      public function Grapple(param1:b2Body)
      {
         super();
         this.grappler = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2DistanceJoint = null;
         super.trigger(param1,param2);
         if(!this.grappled || userData(this.grappled.GetUserData()).dead)
         {
            ud.dead = true;
         }
         if(!this.grappler || userData(this.grappler.GetUserData()).dead || !userData(this.grappler.GetUserData()).trigger)
         {
            ud.trigger = null;
            return;
         }
         var _loc3_:Boolean = userData(this.grappler.GetUserData()).trigger is GrappleGun;
         if(_loc3_)
         {
            if(!(userData(this.grappler.GetUserData()).trigger is GrappleGun))
            {
               ud.trigger = null;
               return;
            }
            if(!GrappleGun(userData(this.grappler.GetUserData()).trigger).joint)
            {
               this.grapplered = false;
            }
         }
         param2.triggered = false;
         if(!this.grapplered)
         {
            this.grapplered = true;
            _loc4_ = -1;
            if(param2.flipped)
            {
               _loc4_ = 1;
            }
            _loc5_ = new b2Vec2(-30 * _loc4_ / Physics.scale,0);
            _loc6_ = new b2Vec2();
            if(_loc3_)
            {
               _loc6_ = new b2Vec2(-30 * _loc4_ / Physics.scale,0);
            }
            _loc7_ = BoxUtils.rotateVec(_loc5_,param1.GetAngle());
            _loc8_ = BoxUtils.rotateVec(_loc6_,this.grappler.GetAngle());
            _loc7_.Add(param1.GetPosition().Copy());
            _loc8_.Add(this.grappler.GetPosition().Copy());
            _loc9_ = Joints.Distance("grapplejoint",param1,this.grappler,_loc7_,_loc8_,10,0,false,0);
            jointUserData(_loc9_.GetUserData()).cuttable = true;
            if(_loc3_)
            {
               GrappleGun(userData(this.grappler.GetUserData()).trigger).joint = _loc9_;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:Boolean = userData(this.grappler.GetUserData()).trigger is GrappleGun;
         if(!_loc7_)
         {
            if(param1.IsStatic())
            {
               ud.dead = true;
               return true;
            }
         }
         if(!param3.sticky)
         {
            return false;
         }
         if(this.grapplered)
         {
            return false;
         }
         var _loc8_:b2WeldJoint = Joints.Weld("weak",body,param1,body.GetPosition().Copy());
         if(_loc8_)
         {
            jointUserData(_loc8_.GetUserData()).forceLimit = 0;
            jointUserData(_loc8_.GetUserData()).defaultFL = 0;
            this.grappled = param1;
         }
         else
         {
            ud.dead = true;
         }
         return true;
      }
   }
}

