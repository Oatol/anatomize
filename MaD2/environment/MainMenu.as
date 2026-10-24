package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import shiny.PFXOutline;
   import shiny.ParticleEffect;
   
   public class MainMenu extends Environment
   {
      
      internal var bods:Boolean = false;
      
      internal var inspirationBody:b2Body;
      
      internal var inspirationBodies:Vector.<b2Body> = new Vector.<b2Body>();
      
      public function MainMenu()
      {
         super(GameState.width,GameState.height);
         _name = "mainmenu";
         gravity = 20;
         wind = 0;
         temperature = 37;
         _backgroundColour = 0;
         _wallColour = 3355443;
         _background = new BitmapData(GameState.width,GameState.height,false);
         _background.fillRect(_background.rect,_backgroundColour);
         enableParticles = false;
         backgroundGore = true;
         _roof = false;
         _floor = false;
         _loop = true;
         spawnHeight = -200;
         spawnX = GameState.width * 0.5;
      }
      
      override public function setupBackground() : void
      {
         super.setupBackground();
         this.setupBodies();
      }
      
      public function setupBodies() : void
      {
         var _loc2_:Item = null;
         var _loc4_:b2Body = null;
         var _loc5_:ParticleEffect = null;
         var _loc7_:Number = NaN;
         var _loc8_:b2Body = null;
         Vars.objDensity = 0;
         Vars.objFriction = 0;
         Vars.objRestitution = 0.2;
         var _loc1_:int = World.togglePreciseEffects;
         World.togglePreciseEffects = 1;
         GameState.environmenting = false;
         _loc2_ = O.getItem("playbutton");
         var _loc3_:Number = _loc2_.scale * 2.5;
         _loc3_ = _loc2_.scale * 3.5;
         _loc4_ = GameState.objects.spawnItem(_loc2_.vertices,[0],_loc3_,_loc2_.name,GameState.width * 0.5,480,1 * Vars.toRadians,_loc2_.colours,"none",null);
         _loc5_ = new PFXOutline(_loc4_);
         _loc5_.attachParticles(1,"shock");
         _loc5_.radius = 2;
         _loc5_.amount = 1;
         _loc5_.speed = 1;
         userData(_loc4_.GetUserData()).pfx = _loc5_;
         userData(_loc4_.GetUserData()).concussing = true;
         Vars.objDensity = 2;
         Vars.objRestitution = 0.01;
         if(!this.bods)
         {
            _loc2_ = O.getItem("bulletofunusualsize");
            _loc7_ = 1;
            this.SetItem(_loc2_.name);
            this.SetItem(_loc2_.name);
            this.SetItem(_loc2_.name);
            this.SetItem(_loc2_.name);
            this.bods = true;
         }
         Vars.objDensity = 0;
         GameState.environmenting = true;
         Vars.objDensity = 1;
         var _loc6_:int = 0;
         while(_loc6_ < 3)
         {
            _loc8_ = GameState.objects.spawnObject("bulletofunusualsize",485 + 50 * _loc6_,300);
            userData(_loc8_.GetUserData()).concussing = true;
            userData(_loc8_.GetUserData()).sharp = true;
            userData(_loc8_.GetUserData()).ignore = "bulletofunusualsize";
            _loc8_.ApplyForce(new b2Vec2(Math.random() * 10000 - 5000,Math.random() * 10000 - 5000),_loc8_.GetWorldCenter());
            _loc8_.ApplyTorque(100000);
            _loc5_ = new PFXOutline(_loc8_);
            _loc5_.attachParticles(1,"shock");
            _loc5_.radius = 2;
            _loc5_.amount = 1;
            _loc5_.speed = 1;
            userData(_loc8_.GetUserData()).pfx = _loc5_;
            _defaultBodies.push(_loc8_);
            _loc6_++;
         }
         World.togglePreciseEffects = _loc1_;
         Vars.objDensity = 0;
         Properties.forceObjInvis = 1;
         _defaultBodies.push(GameState.objects.spawnObject("triangle",210,-700));
         _defaultBodies.push(GameState.objects.spawnObject("triangle",GameState.width - 210,-700));
         Properties.forceObjInvis = 0;
         Vars.objFriction = 0.5;
         Vars.objDensity = 1;
         Vars.objRestitution = 0.2;
         GameState.environmenting = false;
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         wallThickness = 210;
         _borderTop = 2000;
         this.updateWalls();
         _borderTop = 800;
      }
      
      override public function updateWalls() : void
      {
         super.updateWalls();
         this.setupBackground();
      }
      
      override public function update() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         super.update();
         if(Math.random() > 0.9 && Physics.world.GetBodyCount() < 18)
         {
            Main.instance.cleanShrapnel(true);
            _loc1_ = GameState.objects.doll(GameState.width * 0.5,-1000,0,1);
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc1_[_loc2_].ApplyTorque(1000000);
               _loc1_[_loc2_].ApplyImpulse(new b2Vec2(0,200),_loc1_[_loc2_].GetWorldCenter());
               _loc2_++;
            }
         }
      }
      
      public function SetItem(param1:String) : void
      {
         if(this.inspirationBodies.length > 4)
         {
            Body.Destroy(this.inspirationBodies.shift(),"func");
         }
         var _loc2_:Item = O.getItem(param1);
         this.inspirationBodies.push(GameState.objects.spawnItem(_loc2_.vertices,[1],_loc2_.scale,_loc2_.name,GameState.width * 0.5 + Math.random() * GameState.width * 0.25 - GameState.width * 0.125,-500,Math.random() * 360,_loc2_.colours,"none",null));
         this.inspirationBodies[this.inspirationBodies.length - 1].ApplyForce(new b2Vec2(Math.random() * 2 - 1,0),new b2Vec2());
         this.inspirationBodies[this.inspirationBodies.length - 1].GetUserData().sharp = true;
      }
   }
}

