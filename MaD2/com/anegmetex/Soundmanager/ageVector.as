package com.anegmetex.Soundmanager
{
   public class ageVector
   {
      
      internal var x:Number;
      
      internal var y:Number;
      
      public function ageVector(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      internal function copy(param1:ageVector) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      internal function set(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      internal function add(param1:ageVector) : void
      {
         this.x += param1.x;
         this.y += param1.y;
      }
      
      internal function sub(param1:ageVector) : void
      {
         this.x -= param1.x;
         this.y -= param1.y;
      }
      
      internal function mulScalar(param1:Number) : void
      {
         this.x *= param1;
         this.y *= param1;
      }
      
      internal function isEqual(param1:ageVector, param2:Number = 0.00001) : Boolean
      {
         return ageMath.aproxEqual(this.x,param1.x,param2) && ageMath.aproxEqual(this.y,param1.y,param2);
      }
      
      internal function len() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y);
      }
      
      internal function len2() : Number
      {
         return this.x * this.x + this.y * this.y;
      }
      
      internal function trimLen(param1:Number) : void
      {
         if(this.len2() > param1 * param1)
         {
            this.normThis();
            this.mulScalar(param1);
         }
      }
      
      internal function setLen(param1:Number) : void
      {
         this.normThis();
         this.mulScalar(param1);
      }
      
      internal function ProjOnVec(param1:ageVector) : ageVector
      {
         var _loc2_:ageVector = param1.norm();
         _loc2_.mulScalar(this.ProjOnScalar(param1));
         return _loc2_;
      }
      
      internal function ProjOnScalar(param1:ageVector) : Number
      {
         return this.dot(param1) / param1.len();
      }
      
      internal function dot(param1:ageVector) : Number
      {
         return this.x * param1.x + this.y * param1.y;
      }
      
      internal function norm() : ageVector
      {
         var _loc1_:Number = this.len();
         var _loc2_:ageVector = new ageVector(this.x,this.y);
         if(_loc1_)
         {
            _loc2_.x /= _loc1_;
            _loc2_.y /= _loc1_;
         }
         return _loc2_;
      }
      
      internal function normThis() : void
      {
         var _loc1_:Number = this.len();
         if(_loc1_)
         {
            this.x /= _loc1_;
            this.y /= _loc1_;
         }
      }
      
      internal function lerpThis(param1:ageVector, param2:Number) : void
      {
         var _loc3_:ageVector = new ageVector();
         _loc3_.copy(param1);
         _loc3_.sub(this);
         _loc3_.mulScalar(param2);
         this.add(_loc3_);
      }
      
      internal function rot(param1:Number) : void
      {
         var _loc2_:Number = this.x;
         this.x = _loc2_ * Math.cos(param1) - this.y * Math.sin(param1);
         this.y = this.y * Math.cos(param1) + _loc2_ * Math.sin(param1);
      }
      
      internal function rotDeg(param1:Number) : void
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = param1 * Math.PI / 180;
         this.x = _loc2_ * Math.cos(_loc3_) - this.y * Math.sin(_loc3_);
         this.y = this.y * Math.cos(_loc3_) + _loc2_ * Math.sin(_loc3_);
      }
      
      internal function getAngleDeg() : Number
      {
         return Math.atan2(this.y,this.x) / Math.PI * 180;
      }
      
      internal function getAngle() : Number
      {
         return Math.atan2(this.y,this.x);
      }
      
      internal function getAngleDegNorm() : Number
      {
         var _loc1_:Number = Math.atan2(this.y,this.x) / Math.PI * 180;
         if(_loc1_ > 180)
         {
            _loc1_ -= 360;
         }
         else if(_loc1_ < -180)
         {
            _loc1_ += 360;
         }
         return _loc1_;
      }
      
      internal function getAngleNorm() : Number
      {
         var _loc1_:Number = Math.atan2(this.y,this.x);
         if(_loc1_ > Math.PI)
         {
            _loc1_ -= Math.PI * 2;
         }
         else if(_loc1_ < -Math.PI)
         {
            _loc1_ += Math.PI * 2;
         }
         return _loc1_;
      }
   }
}

