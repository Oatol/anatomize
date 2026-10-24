package
{
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ContractTarget
   {
      
      private var _body:b2Body;
      
      private var _type:int;
      
      public function ContractTarget(param1:b2Body, param2:int)
      {
         super();
         this._body = param1;
         this._type = param2;
         this.UpdateIcon();
      }
      
      public function UpdateIcon() : void
      {
         var _loc3_:Bitmap = null;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Array = ["status_dead","status_crippled","tool_shield","tool_relocate","tool_trigger","tool_revive","tool_burn"];
         _loc3_ = new Bitmap(R.getSprite(_loc2_[this._type - 1]));
         _loc3_.x = -_loc3_.width * 0.5;
         _loc3_.y = -_loc3_.height;
         _loc1_.addChild(_loc3_);
         _loc1_.y = -userData(this._body.GetUserData()).height * 0.5 - 4;
         _loc1_.name = "targetIcon";
         userData(this._body.GetUserData()).graphic.addChild(_loc1_);
      }
      
      public function get body() : b2Body
      {
         return this._body;
      }
      
      public function set body(param1:b2Body) : void
      {
         this._body = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
   }
}

