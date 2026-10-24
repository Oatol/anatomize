package
{
   import flash.geom.Rectangle;
   
   public class ContractArea extends Rectangle
   {
      
      private var _spawning:Boolean;
      
      private var _dragging:Boolean;
      
      private var _triggering:Boolean;
      
      private var _cutting:Boolean;
      
      private var _deleting:Boolean;
      
      private var _power:Boolean;
      
      private var _target:Boolean;
      
      public function ContractArea(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super(param1,param2,param3,param4);
      }
      
      public function SetPermissions(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean) : *
      {
         this._spawning = param1;
         this._dragging = param2;
         this._triggering = param3;
         this._cutting = param4;
         this._deleting = param5;
         this._power = param6;
         this._target = param7;
      }
      
      public function GetPermissions() : Vector.<Boolean>
      {
         var _loc1_:Vector.<Boolean> = new Vector.<Boolean>();
         _loc1_.push(this._spawning);
         _loc1_.push(this._dragging);
         _loc1_.push(this._triggering);
         _loc1_.push(this._cutting);
         _loc1_.push(this._deleting);
         _loc1_.push(this._target);
         _loc1_.push(this._power);
         return _loc1_;
      }
      
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function set dragging(param1:Boolean) : void
      {
         this._dragging = param1;
      }
      
      public function get triggering() : Boolean
      {
         return this._triggering;
      }
      
      public function set triggering(param1:Boolean) : void
      {
         this._triggering = param1;
      }
      
      public function get cutting() : Boolean
      {
         return this._cutting;
      }
      
      public function set cutting(param1:Boolean) : void
      {
         this._cutting = param1;
      }
      
      public function get deleting() : Boolean
      {
         return this._deleting;
      }
      
      public function set deleting(param1:Boolean) : void
      {
         this._deleting = param1;
      }
      
      public function get target() : Boolean
      {
         return this._target;
      }
      
      public function set target(param1:Boolean) : void
      {
         this._target = param1;
      }
      
      public function get spawning() : Boolean
      {
         return this._spawning;
      }
      
      public function set spawning(param1:Boolean) : void
      {
         this._spawning = param1;
      }
      
      public function get power() : Boolean
      {
         return this._power;
      }
      
      public function set power(param1:Boolean) : void
      {
         this._power = param1;
      }
   }
}

