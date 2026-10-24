package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Custom extends Environment
   {
      
      internal var _landmarks:Vector.<EnvironmentLandmark> = new Vector.<EnvironmentLandmark>();
      
      internal var _areas:Vector.<EnvironmentArea> = new Vector.<EnvironmentArea>();
      
      public var bounding:Boolean = false;
      
      public var picking:Boolean = false;
      
      public var modifyingIndex:int = -1;
      
      public function Custom()
      {
         super(GameState.width,GameState.height);
         _name = "custom";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _borderLeft = -400;
         _borderRight = 1200;
         _backgroundColour = 1118481;
         _wallColour = 15658734;
         _background = new BitmapData(1600,_height,false);
         enableParticles = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         super.setupBackground();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(15658734);
         _loc1_.graphics.drawRect(750,50,100,100);
         _background.draw(_loc1_,_loc1_.transform.matrix);
         this.initItems();
         backgroundDone();
      }
      
      public function initItems() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:Item = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Vector.<Array> = null;
         var _loc7_:int = 0;
         var _loc8_:EnvironmentArea = null;
         var _loc9_:int = 0;
         var _loc10_:b2Body = null;
         seed = Vars.seed;
         for each(_loc1_ in defaultBodies.slice())
         {
            Body.Destroy(_loc1_,"customEnvironment");
         }
         defaultBodies = new Vector.<b2Body>();
         _loc7_ = 0;
         while(_loc7_ < this.areas.length)
         {
            _loc8_ = this.areas[_loc7_];
            if(_loc8_.item)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc8_.items * clutterDensity * 0.01)
               {
                  _loc2_ = O.getItem(_loc8_.item);
                  _loc6_ = new Vector.<Array>();
                  _loc3_ = _loc2_.scale;
                  _loc4_ = random() * Math.abs(_loc8_.boundsMax.x - _loc8_.boundsMin.x) + _loc8_.boundsMin.x;
                  _loc5_ = random() * Math.abs(_loc8_.boundsMax.y - _loc8_.boundsMin.y) + _loc8_.boundsMin.y;
                  _loc10_ = GameState.objects.spawnItem(_loc2_.vertices,[0],_loc3_,Properties.objBurn("tree"),_loc4_,_loc5_,0,_loc2_.colours,"none",_loc6_);
                  if(_loc10_)
                  {
                     defaultBodies.push(_loc10_);
                  }
                  _loc9_++;
               }
            }
            _loc7_++;
         }
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         super.update();
      }
      
      public function AddLandmark() : *
      {
         this._landmarks.push(new EnvironmentLandmark());
      }
      
      public function AddArea() : *
      {
         this._areas.push(new EnvironmentArea());
      }
      
      public function PickItem(param1:b2Body) : Boolean
      {
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_.saveable)
         {
            return false;
         }
         if(_loc2_.hasBeenCut)
         {
            return false;
         }
         this.areas[this.modifyingIndex].item = _loc2_.name;
         this.initItems();
         return true;
      }
      
      public function SetBounds(param1:b2Vec2, param2:b2Vec2) : void
      {
         this.areas[this.modifyingIndex].boundsMin = param1;
         this.areas[this.modifyingIndex].boundsMax = param2;
         this.initItems();
      }
      
      public function get landmarks() : Vector.<EnvironmentLandmark>
      {
         return this._landmarks;
      }
      
      public function get areas() : Vector.<EnvironmentArea>
      {
         return this._areas;
      }
   }
}

