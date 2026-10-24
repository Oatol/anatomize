package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2MouseJoint;
   import Box2D.Dynamics.Joints.b2MouseJointDef;
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2PrismaticJointDef;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.Joints.b2WeldJointDef;
   import Box2D.Dynamics.b2Body;
   
   public class Joints
   {
      
      public function Joints()
      {
         super();
      }
      
      public static function RemoveAll(param1:b2Body) : *
      {
         var _loc4_:b2Joint = null;
         var _loc2_:Array = [];
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            _loc2_.push(_loc3_.joint);
            _loc3_ = _loc3_.next;
         }
         for each(_loc4_ in _loc2_)
         {
            Physics.world.DestroyJoint(_loc4_);
         }
      }
      
      public static function Revolution(param1:String, param2:b2Body, param3:b2Body, param4:Number, param5:Number, param6:Number = -9000, param7:Number = 9000, param8:Boolean = true, param9:Number = 20000) : b2RevoluteJoint
      {
         if(!param2 || !param3)
         {
            return null;
         }
         if(!param2.GetUserData() || !param3.GetUserData())
         {
            return null;
         }
         if(userData(param2.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param3.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param2.GetUserData()).sensor || userData(param3.GetUserData()).sensor)
         {
            return null;
         }
         if(userData(param2.GetUserData()).trigger)
         {
            if(!userData(param2.GetUserData()).trigger.OnJoint(param3,param1))
            {
               return null;
            }
         }
         if(userData(param3.GetUserData()).trigger)
         {
            if(!userData(param3.GetUserData()).trigger.OnJoint(param2,param1))
            {
               return null;
            }
         }
         if(userData(param2.GetUserData()).armour)
         {
            if(!userData(param2.GetUserData()).armour.OnJoint(param3,param1))
            {
               return null;
            }
         }
         if(userData(param3.GetUserData()).armour)
         {
            if(!userData(param3.GetUserData()).armour.OnJoint(param2,param1))
            {
               return null;
            }
         }
         if(param1 == "revolute")
         {
            if(userData(param2.GetUserData()).alive && userData(param3.GetUserData()).alive)
            {
               param1 = "rag";
            }
         }
         var _loc10_:b2RevoluteJointDef = new b2RevoluteJointDef();
         var _loc11_:jointUserData = new jointUserData(param1);
         _loc11_.forceLimit = param9;
         _loc11_.lowerAngle = param6;
         _loc11_.upperAngle = param7;
         _loc11_.defaultFL = param9;
         _loc11_.defaultLA = param6;
         _loc11_.defaultUA = param7;
         if(Tool.currentJoint == param1)
         {
            _loc11_.lineWidth = Tweak.jointWidth;
            _loc11_.lineColour = Tweak.jointColour;
            _loc11_.lineVisible = Tweak.jointVisible;
            _loc10_.collideConnected = Tweak.jointCollide;
         }
         _loc10_.userData = _loc11_;
         if(param6 != -9000)
         {
            _loc10_.enableLimit = true;
            _loc10_.lowerAngle = param6 / Vars.toDegrees;
         }
         if(param7 != 9000)
         {
            _loc10_.enableLimit = true;
            _loc10_.upperAngle = param7 / Vars.toDegrees;
         }
         _loc10_.Initialize(param2,param3,new b2Vec2(param4 / Physics.scale,param5 / Physics.scale));
         if(param1 == "rag")
         {
            _loc10_.referenceAngle = 0;
         }
         return Physics.world.CreateJoint(_loc10_) as b2RevoluteJoint;
      }
      
      public static function Prismatic(param1:String, param2:b2Body, param3:b2Body, param4:b2Vec2, param5:b2Vec2, param6:Number = 50000, param7:b2Vec2 = null) : b2PrismaticJoint
      {
         var _loc13_:Number = NaN;
         if(userData(param2.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param3.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param2.GetUserData()).sensor || userData(param3.GetUserData()).sensor)
         {
            return null;
         }
         if(jointCapReached(param2,param1))
         {
            return null;
         }
         if(jointCapReached(param3,param1))
         {
            return null;
         }
         var _loc8_:b2PrismaticJointDef = new b2PrismaticJointDef();
         var _loc9_:jointUserData = new jointUserData(param1);
         _loc9_.forceLimit = param6 * 20;
         _loc9_.defaultFL = _loc9_.forceLimit;
         if(Tool.currentJointTool == "piston")
         {
            _loc9_.lineWidth = Tweak.jointWidth;
            _loc9_.lineColour = Tweak.jointColour;
            _loc9_.lineVisible = Tweak.jointVisible;
            _loc8_.collideConnected = Tweak.jointCollide;
         }
         if(Tweak.jointMotorSpeed != 0)
         {
            _loc8_.enableMotor = true;
            _loc8_.motorSpeed = Tweak.jointMotorSpeed;
            _loc8_.maxMotorForce = Tweak.jointMotorForce;
         }
         _loc8_.userData = _loc9_;
         var _loc10_:b2Vec2 = param2.GetPosition().Copy();
         if(param3 != Physics.world.GetGroundBody())
         {
            _loc10_.Subtract(param3.GetPosition().Copy());
         }
         else
         {
            _loc10_.Subtract(param5);
         }
         _loc10_.Normalize();
         var _loc11_:b2Vec2 = param2.GetPosition().Copy();
         if(param7)
         {
            _loc11_.Add(param7);
         }
         _loc8_.Initialize(param2,param3,_loc11_,_loc10_);
         if(Tweak.jointLimited && (param4.x != 0 || param4.y != 0) && (param5.x != 0 || param5.y != 0))
         {
            _loc13_ = Math.sqrt(BoxUtils.vectorDist(param4,param5));
            _loc8_.lowerTranslation = -_loc13_;
            _loc8_.upperTranslation = _loc13_;
            if(!Tweak.jointLimitedLower)
            {
               _loc8_.lowerTranslation = 0;
            }
            if(!Tweak.jointLimitedUpper)
            {
               _loc8_.upperTranslation = 0;
            }
            if(_loc8_.lowerTranslation != 0 || _loc8_.upperTranslation != 0)
            {
               _loc8_.enableLimit = true;
            }
         }
         return Physics.world.CreateJoint(_loc8_) as b2PrismaticJoint;
      }
      
      public static function Distance(param1:String, param2:b2Body, param3:b2Body, param4:b2Vec2, param5:b2Vec2, param6:Number = 0, param7:Number = 0, param8:Boolean = false, param9:Number = 50000) : b2DistanceJoint
      {
         var _loc13_:b2Vec2 = null;
         if(userData(param2.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param3.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param2.GetUserData()).sensor || userData(param3.GetUserData()).sensor)
         {
            return null;
         }
         if(jointCapReached(param2,param1) == true)
         {
            return null;
         }
         if(jointCapReached(param3,param1) == true)
         {
            return null;
         }
         if(userData(param2.GetUserData()).trigger)
         {
            if(!userData(param2.GetUserData()).trigger.OnJoint(param3,param1))
            {
               return null;
            }
         }
         if(userData(param3.GetUserData()).trigger)
         {
            if(!userData(param3.GetUserData()).trigger.OnJoint(param2,param1))
            {
               return null;
            }
         }
         if(userData(param2.GetUserData()).armour)
         {
            if(!userData(param2.GetUserData()).armour.OnJoint(param3,param1))
            {
               return null;
            }
         }
         if(userData(param3.GetUserData()).armour)
         {
            if(!userData(param3.GetUserData()).armour.OnJoint(param2,param1))
            {
               return null;
            }
         }
         if(param4.x == param5.x && param4.y == param5.y)
         {
            param5.y -= 0.000001;
         }
         var _loc10_:b2DistanceJointDef = new b2DistanceJointDef();
         var _loc11_:jointUserData = new jointUserData(param1);
         _loc11_.forceLimit = param9;
         _loc11_.defaultFL = _loc11_.forceLimit;
         _loc11_.defaultLA = -60;
         _loc11_.defaultUA = 60;
         if(Tool.currentJoint == param1)
         {
            _loc11_.lineWidth = Tweak.jointWidth;
            _loc11_.lineColour = Tweak.jointColour;
            _loc11_.lineVisible = Tweak.jointVisible;
            if(Tweak.jointCenter)
            {
               if(userData(param2.GetUserData()).name != "ground")
               {
                  param4 = param2.GetPosition().Copy();
               }
               if(userData(param3.GetUserData()).name != "ground")
               {
                  param5 = param3.GetPosition().Copy();
               }
            }
         }
         _loc10_.userData = _loc11_;
         _loc10_.collideConnected = param8;
         _loc10_.Initialize(param2,param3,param4,param5);
         _loc10_.frequencyHz = param6;
         _loc10_.dampingRatio = param7;
         var _loc12_:b2DistanceJoint = Physics.world.CreateJoint(_loc10_) as b2DistanceJoint;
         if(param2 != Physics.world.GetGroundBody())
         {
            _loc13_ = param2.GetPosition().Copy();
            param2.SetXForm(new b2Vec2(-50,-50),param2.GetAngle());
            param2.SetXForm(_loc13_,param2.GetAngle());
         }
         if(param3 != Physics.world.GetGroundBody())
         {
            _loc13_ = param3.GetPosition().Copy();
            param3.SetXForm(new b2Vec2(50,-50),param3.GetAngle());
            param3.SetXForm(_loc13_,param3.GetAngle());
         }
         return _loc12_;
      }
      
      public static function Weld(param1:String, param2:b2Body, param3:b2Body, param4:b2Vec2, param5:Number = 100000, param6:Boolean = true) : b2WeldJoint
      {
         if(userData(param2.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param3.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param2.GetUserData()).fixedrotation && userData(param3.GetUserData()).fixedrotation)
         {
            GameState.ui.showTooltip(userData(param2.GetUserData()).graphic,"Fixed rotation items can\'t be welded (physics engine thing.)\n\n",10,2000,200);
            return null;
         }
         if(userData(param2.GetUserData()).sensor || userData(param3.GetUserData()).sensor)
         {
            return null;
         }
         if(param6)
         {
            if(param1 != "weak" && param1 != "armour")
            {
               if(jointCapReached(param2,param1))
               {
                  return null;
               }
               if(jointCapReached(param3,param1))
               {
                  return null;
               }
            }
         }
         if(userData(param2.GetUserData()).trigger)
         {
            if(!userData(param2.GetUserData()).trigger.OnJoint(param3,param1))
            {
               return null;
            }
         }
         if(userData(param3.GetUserData()).trigger)
         {
            if(!userData(param3.GetUserData()).trigger.OnJoint(param2,param1))
            {
               return null;
            }
         }
         if(userData(param2.GetUserData()).armour)
         {
            if(!userData(param2.GetUserData()).armour.OnJoint(param3,param1))
            {
               return null;
            }
         }
         if(userData(param3.GetUserData()).armour)
         {
            if(!userData(param3.GetUserData()).armour.OnJoint(param2,param1))
            {
               return null;
            }
         }
         var _loc7_:b2WeldJointDef = new b2WeldJointDef();
         var _loc8_:jointUserData = new jointUserData(param1);
         _loc8_.forceLimit = param5;
         _loc8_.defaultFL = _loc8_.forceLimit;
         _loc8_.defaultLA = -60;
         _loc8_.defaultUA = 60;
         if(Tool.currentJoint == param1 || param1 == "weldjoint")
         {
            _loc8_.lineWidth = Tweak.jointWidth;
            _loc8_.lineColour = Tweak.jointColour;
            _loc8_.lineVisible = Tweak.jointVisible;
         }
         _loc7_.userData = _loc8_;
         _loc7_.collideConnected = false;
         param4 = new b2Vec2((param2.GetPosition().x + param3.GetPosition().x) * 0.5,(param2.GetPosition().y + param3.GetPosition().y) * 0.5);
         _loc7_.Initialize(param2,param3,param4);
         return Physics.world.CreateJoint(_loc7_) as b2WeldJoint;
      }
      
      public static function Pin(param1:String, param2:b2Body, param3:b2Vec2, param4:Number) : b2MouseJoint
      {
         if(userData(param2.GetUserData()).resistJoints && !IO.incrementalLoading)
         {
            return null;
         }
         if(userData(param2.GetUserData()).sensor)
         {
            return null;
         }
         if(jointCapReached(param2,param1))
         {
            return null;
         }
         var _loc5_:b2MouseJointDef = new b2MouseJointDef();
         var _loc6_:jointUserData = new jointUserData(param1);
         if(userData(param2.GetUserData()).trigger)
         {
            if(!userData(param2.GetUserData()).trigger.OnJoint(param2,param1))
            {
               return null;
            }
         }
         if(userData(param2.GetUserData()).armour)
         {
            if(!userData(param2.GetUserData()).armour.OnJoint(param2,param1))
            {
               return null;
            }
         }
         _loc6_.forceLimit = param4;
         _loc6_.defaultFL = _loc6_.forceLimit;
         _loc6_.defaultLA = -60;
         _loc6_.defaultUA = 60;
         if(Tool.currentJoint == param1)
         {
            _loc6_.lineWidth = Tweak.jointWidth;
            _loc6_.lineColour = Tweak.jointColour;
            _loc6_.lineVisible = Tweak.jointVisible;
            if(Tweak.jointCenter)
            {
               param3 = param2.GetPosition().Copy();
            }
         }
         _loc5_.userData = _loc6_;
         _loc5_.body1 = Physics.world.GetGroundBody();
         _loc5_.body2 = param2;
         _loc5_.target.Set(param3.x,param3.y);
         _loc5_.maxForce = 900000 * param2.GetMass();
         _loc5_.timeStep = Tweak.m_timeStep;
         return Physics.world.CreateJoint(_loc5_) as b2MouseJoint;
      }
      
      public static function ToolToJoint(param1:String) : String
      {
         var _loc2_:Array = [Tool.JOINT,Tool.ROPE,Tool.WELD,Tool.PIN,Tool.DOLL,Tool.PISTON];
         var _loc3_:Array = ["objjoint","ropejoint","weldjoint","bgjoint","revolute","pistonjoint"];
         var _loc4_:String = "ojjoint";
         var _loc5_:int = _loc2_.indexOf(param1);
         if(_loc5_ != -1)
         {
            _loc4_ = _loc3_[_loc5_];
         }
         return _loc4_;
      }
      
      public static function Colour(param1:String) : String
      {
         var _loc2_:Array = ["objjoint","ropejoint","weldjoint","bgjoint","equip","rag","revolute","pistonjoint"];
         var _loc3_:Array = ["FFFFCC","663300","808080","FFFFFF","FFFFFF","FFFFFF","CCFFFF","333338"];
         var _loc4_:String = "FFFFFF";
         var _loc5_:int = _loc2_.indexOf(param1);
         if(_loc5_ != -1)
         {
            _loc4_ = _loc3_[_loc5_];
         }
         return _loc4_;
      }
      
      public static function Name(param1:String) : String
      {
         var _loc2_:Array = ["objjoint","ropejoint","weldjoint","bgjoint","equip","rag","revolute","pistonjoint"];
         var _loc3_:Array = ["Joint","Rope","Weld","Pin","Armour","Doll","Revolute","Piston"];
         var _loc4_:String = "Miscellaneous";
         var _loc5_:int = _loc2_.indexOf(param1);
         if(_loc5_ != -1)
         {
            _loc4_ = _loc3_[_loc5_];
         }
         return _loc4_;
      }
      
      public static function Icon(param1:String) : String
      {
         var _loc2_:Array = ["Joint","Rope","Weld","Pin","Armour","Doll","Revolute","Piston"];
         var _loc3_:Array = ["tool_joint","tool_rope","tool_weld","tool_pin","iconarmour","doll_large","tool_revo","tool_piston"];
         var _loc4_:String = "iconrandom";
         var _loc5_:int = _loc2_.indexOf(param1);
         if(_loc5_ != -1)
         {
            _loc4_ = _loc3_[_loc5_];
         }
         return _loc4_;
      }
      
      public static function NumJoints(param1:b2Body) : int
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         var _loc4_:b2JointEdge = param1.GetJointList();
         while(_loc4_)
         {
            if(param1 != Physics.world.GetGroundBody())
            {
               _loc3_ = jointUserData(_loc4_.joint.GetUserData()).name;
               if(_loc3_ != "mouse")
               {
                  if(_loc3_ != "snarejoint")
                  {
                     if(_loc3_ != "vinejoint")
                     {
                        if(_loc3_ != "webjoint")
                        {
                           _loc2_++;
                        }
                     }
                  }
               }
            }
            _loc4_ = _loc4_.next;
         }
         return _loc2_;
      }
      
      public static function HasJoint(param1:b2Body, param2:String) : *
      {
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            if(param1 != Physics.world.GetGroundBody())
            {
               if(param2 == jointUserData(_loc3_.joint.GetUserData()).name)
               {
                  return true;
               }
            }
            _loc3_ = _loc3_.next;
         }
         return false;
      }
      
      public static function GetJoints(param1:b2Body, param2:String = "all") : Array
      {
         var _loc3_:Array = [];
         var _loc4_:b2JointEdge = param1.GetJointList();
         while(_loc4_)
         {
            if(param1 != Physics.world.GetGroundBody())
            {
               if(param2 == "all" || param2 == jointUserData(_loc4_.joint.GetUserData()).name)
               {
                  _loc3_.push(_loc4_.joint);
               }
            }
            _loc4_ = _loc4_.next;
         }
         return _loc3_;
      }
      
      public static function Destroy(param1:b2Body, param2:String = "all") : void
      {
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            if(param2 == "all" || param2 == jointUserData(_loc3_.joint.GetUserData()).name)
            {
               jointUserData(_loc3_.joint.GetUserData()).dead = true;
            }
            _loc3_ = _loc3_.next;
         }
      }
      
      public static function DestroyJoint(param1:b2Joint) : void
      {
         var _loc2_:b2Body = param1.GetBody1();
         var _loc3_:b2Body = param1.GetBody2();
         var _loc4_:userData = _loc2_.GetUserData();
         var _loc5_:userData = _loc3_.GetUserData();
         if(_loc4_.armour)
         {
            _loc4_.armour.Detach();
         }
         if(_loc5_.armour)
         {
            _loc5_.armour.Detach();
         }
         Physics.world.DestroyJoint(param1);
      }
      
      public static function Other(param1:b2Joint, param2:b2Body) : b2Body
      {
         var _loc3_:b2Body = param1.GetBody1();
         var _loc4_:b2Body = param1.GetBody2();
         if(!_loc3_)
         {
            return _loc4_;
         }
         if(!_loc4_)
         {
            return _loc3_;
         }
         if(_loc3_ == param2)
         {
            return _loc4_;
         }
         if(_loc4_ == param2)
         {
            return _loc3_;
         }
         return null;
      }
      
      private static function jointCapReached(param1:b2Body, param2:String) : Boolean
      {
         return false;
      }
   }
}

