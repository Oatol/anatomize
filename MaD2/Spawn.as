package
{
   import Box2D.Collision.Shapes.b2CircleDef;
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   
   public class Spawn
   {
      
      public function Spawn()
      {
         super();
      }
      
      public static function Walls(param1:String = "a", param2:Number = -1, param3:Number = -1, param4:Number = 16, param5:Vector.<Array> = null, param6:Boolean = true) : b2Body
      {
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc7_:b2Body = null;
         var _loc8_:b2BodyDef = new b2BodyDef();
         var _loc9_:b2PolygonDef = new b2PolygonDef();
         if(param2 == -1)
         {
            _loc9_.friction = Vars.objFriction;
         }
         if(param3 == -1)
         {
            _loc9_.restitution = Vars.objRestitution;
         }
         var _loc10_:Number = GameState.environment.borderLeft;
         var _loc11_:Number = GameState.environment.borderRight;
         var _loc12_:Number = GameState.environment.borderTop;
         if(param1 == "u")
         {
            _loc8_.position.Set((_loc11_ + _loc10_) * 0.5 / Physics.scale,(-_loc12_ + GameState.height + param4 * 0.5) / Physics.scale);
            _loc8_.userData = Properties.objectProperties("wall");
            _loc7_ = Physics.world.CreateBody(_loc8_);
            _loc9_.userData = Properties.shapeProperties("777777");
            _loc9_.SetAsBox((_loc11_ - _loc10_) * 0.5 / Physics.scale,param4 * 0.5 / Physics.scale);
            _loc7_.CreateShape(_loc9_);
            userData(_loc7_.GetUserData()).width = _loc11_ - _loc10_;
            userData(_loc7_.GetUserData()).height = param4;
         }
         if(param1 == "d")
         {
            _loc8_.position.Set((_loc11_ + _loc10_) * 0.5 / Physics.scale,(GameState.height - param4 * 0.5) / Physics.scale);
            _loc8_.userData = Properties.objectProperties("wall");
            _loc7_ = Physics.world.CreateBody(_loc8_);
            _loc9_.userData = Properties.shapeProperties("777777");
            _loc9_.SetAsBox((_loc11_ - _loc10_) * 0.5 / Physics.scale,param4 * 0.5 / Physics.scale);
            _loc7_.CreateShape(_loc9_);
            userData(_loc7_.GetUserData()).width = _loc11_ - _loc10_;
            userData(_loc7_.GetUserData()).height = param4;
         }
         if(param1 == "r")
         {
            _loc13_ = _loc11_;
            _loc8_.position.Set((_loc13_ - param4 * 0.5) / Physics.scale,(-_loc12_ * 0.5 + GameState.height) / Physics.scale);
            _loc8_.userData = Properties.objectProperties("wall");
            _loc7_ = Physics.world.CreateBody(_loc8_);
            _loc9_.userData = Properties.shapeProperties("777777");
            _loc9_.SetAsBox(param4 * 0.5 / Physics.scale,_loc12_ * 0.5 / Physics.scale);
            _loc7_.CreateShape(_loc9_);
            userData(_loc7_.GetUserData()).width = param4;
            userData(_loc7_.GetUserData()).height = GameState.height;
         }
         if(param1 == "l")
         {
            _loc13_ = _loc10_;
            _loc8_.position.Set((_loc13_ + param4 * 0.5) / Physics.scale,(-_loc12_ * 0.5 + GameState.height) / Physics.scale);
            _loc8_.userData = Properties.objectProperties("wall");
            _loc7_ = Physics.world.CreateBody(_loc8_);
            _loc9_.userData = Properties.shapeProperties("777777");
            _loc9_.SetAsBox(param4 * 0.5 / Physics.scale,_loc12_ * 0.5 / Physics.scale);
            _loc7_.CreateShape(_loc9_);
            userData(_loc7_.GetUserData()).width = param4;
            userData(_loc7_.GetUserData()).height = GameState.height;
         }
         userData(_loc7_.GetUserData()).skin = param5;
         if(!param6)
         {
            userData(_loc7_.GetUserData()).stainless = true;
         }
         userData(_loc7_.GetUserData()).graphic = BoxUtils.bodyToSprite(_loc7_,_loc7_.GetUserData().size);
         userData(_loc7_.GetUserData()).graphic.x = _loc7_.GetPosition().x * Physics.scale;
         userData(_loc7_.GetUserData()).graphic.y = _loc7_.GetPosition().y * Physics.scale;
         userData(_loc7_.GetUserData()).graphic.cacheAsBitmap = true;
         Main.instance.itemSprite.addChild(userData(_loc7_.GetUserData()).graphic);
         return _loc7_;
      }
      
      public static function circle(param1:Number, param2:Number, param3:Number, param4:userData, param5:Array, param6:Boolean = true) : b2Body
      {
         param4.width = param3;
         param4.height = param3;
         param4.saveable = false;
         var _loc7_:b2BodyDef = new b2BodyDef();
         _loc7_.userData = param4;
         _loc7_.userData.health = 100;
         var _loc8_:b2CircleDef = new b2CircleDef();
         _loc8_.density = Vars.objDensity * param5[0];
         _loc8_.friction = Vars.objFriction * param5[1];
         _loc8_.restitution = Vars.objRestitution * param5[2];
         if(param5[3])
         {
            _loc7_.linearDamping = param5[3];
         }
         _loc8_.radius = param3 / Physics.scale * Vars.objSize;
         _loc8_.userData = new ShapeUserData(param4.name);
         _loc7_.position.Set(param1 / Physics.scale,param2 / Physics.scale);
         _loc7_.linearDamping = Vars.objDampLinear;
         var _loc9_:b2Body = Physics.world.CreateBody(_loc7_);
         _loc9_.CreateShape(_loc8_);
         if(param6)
         {
            _loc9_.SetMassFromShapes();
         }
         _loc9_.SetUserData(param4);
         param4.body = _loc9_;
         return _loc9_;
      }
   }
}

