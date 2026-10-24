package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class ArmourStand extends Trigger
   {
      
      internal var torsoPos:b2Vec2 = new b2Vec2(0,-40);
      
      internal var midPos:b2Vec2 = new b2Vec2(0,-20);
      
      internal var skirtPos:b2Vec2 = new b2Vec2(0,-20);
      
      internal var headPos:b2Vec2 = new b2Vec2(0,-70);
      
      internal var glovePosL:b2Vec2 = new b2Vec2(-40,-40);
      
      internal var glovePosR:b2Vec2 = new b2Vec2(40,-40);
      
      internal var shoulderPosL:b2Vec2 = new b2Vec2(-30,-30);
      
      internal var shoulderPosR:b2Vec2 = new b2Vec2(30,-30);
      
      internal var thighPosL:b2Vec2 = new b2Vec2(-10,30);
      
      internal var thighPosR:b2Vec2 = new b2Vec2(10,30);
      
      internal var bootPosL:b2Vec2 = new b2Vec2(-20,30);
      
      internal var bootPosR:b2Vec2 = new b2Vec2(20,30);
      
      internal var helmet:Boolean = false;
      
      internal var torso:Boolean = false;
      
      internal var mid:Boolean = false;
      
      internal var skirt:Boolean = false;
      
      internal var handL:Boolean = false;
      
      internal var handR:Boolean = false;
      
      internal var shoulderL:Boolean = false;
      
      internal var shoulderR:Boolean = false;
      
      internal var thighL:Boolean = false;
      
      internal var thighR:Boolean = false;
      
      internal var footL:Boolean = false;
      
      internal var footR:Boolean = false;
      
      internal var equipped:Vector.<b2Body> = new Vector.<b2Body>();
      
      public function ArmourStand()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Boolean = false;
         var _loc10_:b2JointEdge = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(body,100,100);
         var _loc6_:Number = 0;
         for each(_loc7_ in _loc3_)
         {
            if(this.equipped.indexOf(_loc7_) == -1)
            {
               _loc4_ = userData(_loc7_.GetUserData());
               if((Boolean(_loc4_)) && Boolean(_loc4_.armour))
               {
                  if(!this.torso && _loc4_.armour is ArmourTorso && ArmourTorso(_loc4_.armour).bodypart == 0)
                  {
                     _loc8_ = this.torsoPos;
                     this.torso = true;
                  }
                  else if(!this.mid && _loc4_.armour is ArmourTorso && ArmourTorso(_loc4_.armour).bodypart == 1)
                  {
                     _loc8_ = this.midPos;
                     this.mid = true;
                  }
                  else if(_loc4_.armour is ArmourBack)
                  {
                     _loc8_ = this.midPos;
                  }
                  else if(!this.skirt && _loc4_.armour is ArmourTorso && ArmourTorso(_loc4_.armour).bodypart == 2)
                  {
                     _loc8_ = this.skirtPos;
                     this.skirt = true;
                  }
                  else if(!this.helmet && _loc4_.armour is ArmourHelmet)
                  {
                     _loc8_ = this.headPos;
                     this.helmet = true;
                  }
                  else if(!this.handL && _loc4_.armour is ArmourGlove)
                  {
                     _loc8_ = this.glovePosL;
                     this.handL = true;
                     _loc6_ = 90;
                  }
                  else if(!this.handR && _loc4_.armour is ArmourGlove)
                  {
                     _loc8_ = this.glovePosR;
                     _loc8_.x -= _loc4_.triggerPos.x;
                     this.handR = true;
                     _loc6_ = -90;
                  }
                  else if(!this.shoulderL && _loc4_.armour is ArmourShoulder)
                  {
                     _loc8_ = this.shoulderPosL;
                     this.shoulderL = true;
                  }
                  else if(!this.shoulderR && _loc4_.armour is ArmourShoulder)
                  {
                     _loc8_ = this.shoulderPosR;
                     _loc8_.x -= _loc4_.triggerPos.x;
                     this.shoulderR = true;
                  }
                  else if(!this.thighL && _loc4_.armour is ArmourThigh)
                  {
                     _loc8_ = this.thighPosL;
                     this.thighL = true;
                  }
                  else if(!this.thighR && _loc4_.armour is ArmourThigh)
                  {
                     _loc8_ = this.thighPosR;
                     this.thighR = true;
                  }
                  else if(!this.footL && _loc4_.armour is ArmourBoot)
                  {
                     _loc8_ = this.bootPosL;
                     this.footL = true;
                  }
                  else if(!this.footR && _loc4_.armour is ArmourBoot)
                  {
                     _loc8_ = this.bootPosR;
                     this.footR = true;
                  }
               }
               if(_loc8_)
               {
                  _loc9_ = false;
                  _loc10_ = _loc7_.GetJointList();
                  while(_loc10_)
                  {
                     if(jointUserData(_loc10_.joint.GetUserData()).name == "armour")
                     {
                        _loc9_ = true;
                        break;
                     }
                     _loc10_ = _loc10_.next;
                  }
                  if(!_loc9_)
                  {
                     _loc5_ = pixelCenter.Copy();
                     _loc5_.Add(_loc8_);
                     _loc5_.Add(_loc4_.triggerPos);
                     _loc5_.Multiply(1 / Physics.scale);
                     _loc7_.SetLinearVelocity(new b2Vec2());
                     _loc7_.SetAngularVelocity(0);
                     _loc7_.SetXForm(_loc5_,bodyAngle + _loc6_ * Vars.toRadians);
                     Joints.Weld("armour",_loc7_,body,bodyCenter,10000,false);
                     this.equipped.push(_loc7_);
                     break;
                  }
               }
            }
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         var _loc1_:b2JointEdge = body.GetJointList();
         while(_loc1_)
         {
            jointUserData(_loc1_.joint.GetUserData()).dead = true;
            _loc1_ = _loc1_.next;
         }
         this.equipped = new Vector.<b2Body>();
         this.helmet = false;
         this.torso = false;
         this.mid = false;
         this.skirt = false;
         this.handL = false;
         this.handR = false;
         this.shoulderL = false;
         this.shoulderR = false;
         this.thighL = false;
         this.thighR = false;
         this.footL = false;
         this.footR = false;
      }
   }
}

