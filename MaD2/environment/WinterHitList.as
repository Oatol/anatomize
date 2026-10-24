package environment
{
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import shiny.PFXGlow;
   import triggers.Disintegrate;
   import triggers.TradingCard;
   
   public class WinterHitList extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var rain2:ParticleSystem;
      
      internal var spawner:Timer;
      
      public var sword:b2Body;
      
      private var tf:TextField;
      
      private var fader:Sprite;
      
      public var drone:Sprite;
      
      internal var healthbars:int;
      
      internal var dollbars:int;
      
      internal var edgepan:int;
      
      internal var doll:Array = [];
      
      internal var spawning:Boolean = false;
      
      internal var init:Boolean = false;
      
      internal var skipped:Boolean = false;
      
      internal var tutorial:int = -1;
      
      internal var tutoriallines:Array = ["Hello, person.","Hello, person.","Hello, person.                       ","I\'ve received a list of naughty dolls,\nand an assortment of \'gifts\' for each of them.","Trigger the cards to see the gifts inside.\nSpawn and use the items as usual.\nReset to quit.","Give them what they deserve.\nHappy gifting."];
      
      internal var lines:Array = [];
      
      internal var deadlines:Array = [];
      
      internal var naughty:Array = ["naughty","naughty","naughty","naughty","naughty","naughty","naughty","naughty","evil","wicked","rowdy","annoying","badly-behaved","disobedient","fiendish","puny","nasty","intractable","rascally","unruly","aggravating","bad","bad, bad,","very bad","very naughty","extremely naughty","TURBO NAUGHTY","malicious","nefarious","villainous","depraved","foul","atrocious"];
      
      internal var pumpkincount:int = 5;
      
      internal var switchLine:Boolean = true;
      
      internal var line:String = "Hello, person.";
      
      public function WinterHitList()
      {
         Main.instance.stage.focus = null;
         Main.instance.reset(false,false);
         super(GameState.width,GameState.height);
         enableClutter = false;
         enableFiller = false;
         enableParticles = false;
         enableSeed = false;
         _name = "winterhitlist";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _backgroundColour = 14149611;
         _wallColour = 9486802;
         spawnX = 2000;
         _background = new BitmapData(1600,600,false,_backgroundColour);
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_gas"));
         this.rain2 = new ParticleSystem("rain2",_width,_height,R.getSprite("p_snowBig"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 0.01;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 1;
         this.rain.particleHealth = 1000;
         this.rain.particleWander = 0.5;
         this.rain.particleFriction = 0.95;
         this.rain2.useWorldGravity = false;
         this.rain2.particleGravity = 0.5;
         this.rain2.particleFade = 1;
         this.rain2.particleFadeRandom = 10;
         this.rain2.particleHealth = 1000;
         this.rain2.particleRestitution = 0;
         this.rain2.particleFriction = 0.9;
         this.rain2.particleWander = 1;
         _particleSystems.push(this.rain);
         _particleSystems.push(this.rain2);
         _roof = false;
         _walls = true;
         _wallL = true;
         _wallR = true;
         _floor = true;
         _loop = false;
         wallThickness = 16;
         this.lines.push("This NAUGHTY doll\nate RANDOM too many cookies.");
         this.lines.push("This NAUGHTY doll\nused social media.");
         this.lines.push("This NAUGHTY doll\ndidn\'t read the user manual before using a stapler.");
         this.lines.push("This NAUGHTY doll\ndidn\'t return a library book on time.");
         this.lines.push("This NAUGHTY doll\nplayed music through a phone speaker.");
         this.lines.push("This NAUGHTY doll\nfailed to predict an earthquake.");
         this.lines.push("This NAUGHTY doll\nthrew a yellow snowball.");
         this.lines.push("This NAUGHTY doll\nreleased a burst of neutron radiation.");
         this.lines.push("This NAUGHTY doll\ncaused a core to go supercritical.");
         this.lines.push("This NAUGHTY doll\ncovered up what The Lab did.");
         this.lines.push("This NAUGHTY doll\ndivided by zero.");
         this.lines.push("This NAUGHTY doll\nspilled water on magnesium.");
         this.lines.push("This NAUGHTY doll\nstole moon rocks.");
         this.lines.push("This NAUGHTY doll\ncaused the end of the world in another dimension.");
         this.lines.push("This NAUGHTY doll\ndestroyed the second moon and erased everyone\'s memories about it.");
         this.lines.push("This NAUGHTY doll\nate butter with a spoon.");
         this.lines.push("This NAUGHTY doll\nforgot mothers\' day.");
         this.lines.push("This NAUGHTY doll\nforgot fathers\' day.");
         this.lines.push("This NAUGHTY doll\nforgot your birthday.");
         this.lines.push("This NAUGHTY doll\nthrew an alligator\nthrough a drive-through window.");
         this.lines.push("This NAUGHTY doll\nplayed the same song RANDOM times in a row.");
         this.lines.push("This NAUGHTY doll\naccidentally everything.");
         this.lines.push("This NAUGHTY doll\nstole a stapler.");
         this.lines.push("This NAUGHTY doll\npet a cat the wrong way.");
         this.lines.push("This NAUGHTY doll\ndidn\'t pet a dog.");
         this.lines.push("This NAUGHTY doll\ntravelled back in time RANDOM years and broke the timeline.");
         this.lines.push("This NAUGHTY doll\nabducted an extraterrestrial.");
         this.lines.push("This NAUGHTY doll\nstole RANDOM staplers.");
         this.lines.push("This NAUGHTY doll\nstole RANDOM sacks of staplers.");
         this.lines.push("This NAUGHTY doll\nstole RANDOM boxes staplers.");
         this.lines.push("This NAUGHTY doll\napproves of advertising.");
         this.lines.push("This NAUGHTY doll\nraided an office-supply truck.");
         this.lines.push("This NAUGHTY doll\nfilled a bank vault with tiny banks.");
         this.lines.push("This NAUGHTY doll\nused ketchup as toothpaste.");
         this.lines.push("This NAUGHTY doll\nyelled at a cloud.");
         this.lines.push("This NAUGHTY doll\nopened a gift early.");
         this.lines.push("This NAUGHTY doll\ndidn\'t wash hands.");
         this.lines.push("This NAUGHTY doll\nsplit an atom.");
         this.lines.push("This NAUGHTY doll\ncheated in a single-player game.");
         this.lines.push("This NAUGHTY doll\nsaid an emoji out loud.");
         this.lines.push("This NAUGHTY doll\ndidn\'t thank the janitor drone.");
         this.lines.push("This NAUGHTY doll\ncommented \'first\'.");
         this.lines.push("This NAUGHTY doll\nbroke a tradition.");
         this.lines.push("This NAUGHTY doll\ndidn\'t eat enough vegetables.");
         this.lines.push("This NAUGHTY doll\ncommitted tax fraud.");
         this.lines.push("This NAUGHTY doll\nhas a favourite car.");
         this.lines.push("This NAUGHTY doll\nwas loyal to a brand.");
         this.lines.push("This NAUGHTY doll\ndidn\'t participate in capitalism.");
         this.lines.push("This NAUGHTY doll\nwas proven guilty in a court of law.");
         this.lines.push("This NAUGHTY doll\ncalled instead of texting.");
         this.lines.push("This NAUGHTY doll\nscheduled a meeting that could\'ve been an email.");
         this.lines.push("This NAUGHTY doll\ndid a wheelie. With a train.");
         this.lines.push("This NAUGHTY doll\nfailed to notice a new haircut.");
         this.lines.push("This NAUGHTY doll\ndidn\'t conform.");
         this.lines.push("This NAUGHTY doll\nliked a pun.");
         this.lines.push("This NAUGHTY doll\npossessed a permanent marker.");
         this.lines.push("This NAUGHTY doll\nlittered.");
         this.lines.push("This NAUGHTY doll\ndisposed of e-waste improperly.");
         this.lines.push("This NAUGHTY doll\ncaused an infestation.");
         this.lines.push("This NAUGHTY doll\ncaused a butterfly effect.");
         this.lines.push("This NAUGHTY doll\npressed the wrong button.");
         this.lines.push("This NAUGHTY doll\nwas in the wrong place at the wrong time.");
         this.lines.push("This NAUGHTY doll\nwas in the right place at the wrong time.");
         this.lines.push("This NAUGHTY doll\nwas in the wrong place at the right time.");
         this.lines.push("This NAUGHTY doll\nbroke Newton\'s third law.");
         this.lines.push("This NAUGHTY doll\nbroke the laws of physics.");
         this.lines.push("This NAUGHTY doll\ndisobeyed gravity.");
         this.lines.push("This NAUGHTY doll\ntrusted the system.");
         this.lines.push("This NAUGHTY doll\nplayed the wrong game.");
         this.lines.push("This NAUGHTY doll\nlost the game.");
         this.lines.push("This NAUGHTY doll\nset a dangerous precedent.");
         this.lines.push("This NAUGHTY doll\ndemoted Pluto.");
         this.lines.push("This NAUGHTY doll\ncaused a solar flare.");
         this.lines.push("This NAUGHTY doll\ncaused a cosmic storm.");
         this.lines.push("This NAUGHTY doll\ndestroyed a whole planet.");
         this.lines.push("This NAUGHTY doll\ncaused a black hole.");
         this.lines.push("This NAUGHTY doll\nspilled the beans.");
         this.lines.push("This NAUGHTY doll\ntold the truth.");
         this.lines.push("This NAUGHTY doll\nwas complicit.");
         this.lines.push("This NAUGHTY doll\ncovered up a crime.");
         this.lines.push("This NAUGHTY doll\ndoesn\'t have a phone case.");
         this.lines.push("This NAUGHTY doll\nsat in a chair wrong.");
         this.lines.push("This NAUGHTY doll\ncaused the prevalence of microtransactions in modern games.");
         this.lines.push("This NAUGHTY doll\ncaused the paradigm shift towards subscription services.");
         this.lines.push("This NAUGHTY doll\ncaused a paradigm shift.");
      }
      
      override public function setupBackground() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.setupBackground();
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain.addParticles(1,_loc1_,580,0,0,4,4);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 10)
         {
            this.rain.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 50)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc1_,Math.random() * 600,0,0,4,4);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 10)
         {
            this.rain2.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc3_++;
         }
      }
      
      public function reset() : void
      {
         if(this.spawner)
         {
            this.spawner.stop();
         }
         this.removeGraphics();
         Tweener.removeAllTweens();
         GameState.menuHandler.getMenu("Main").open();
         GameState.menuHandler.getMenu("Toolbox").open();
         World.toggleEdgePan = this.edgepan;
         World.toggleHealthbars = this.healthbars;
         World.toggleDollbars = this.dollbars;
         Main.instance.changeEnvironment("lab");
         Main.instance.reset();
         Main.instance.loadedLevel = "";
         Main.instance.currentSave = "";
      }
      
      private function removeGraphics() : void
      {
         var _loc1_:DisplayObject = Main.instance.stage.getChildByName("openworlddrone");
         var _loc2_:DisplayObject = Main.instance.stage.getChildByName("openworldtf");
         var _loc3_:DisplayObject = Main.instance.stage.getChildByName("openworldfader");
         if(_loc1_)
         {
            Main.instance.stage.removeChild(_loc1_);
         }
         if(_loc2_)
         {
            Main.instance.stage.removeChild(_loc2_);
         }
         if(_loc3_)
         {
            Main.instance.stage.removeChild(_loc3_);
         }
         sounds.stop("halloweenmusic");
      }
      
      public function Init() : *
      {
         this.init = true;
         Main.instance.reset(false,true);
         _roof = true;
         _walls = true;
         _wallL = true;
         _wallR = true;
         _floor = true;
         _loop = false;
         wallThickness = 16;
         updateWalls();
         this.edgepan = World.toggleEdgePan;
         this.healthbars = World.toggleHealthbars;
         this.dollbars = World.toggleDollbars;
         World.toggleHealthbars = 0;
         World.toggleDollbars = 0;
         World.toggleEdgePan = 0;
         Tool.drag();
         var _loc1_:Number = 125;
         this.tutorial = 1;
         this.drone = O.getItem("dronespeaker").updateGraphic();
         this.drone.x = 700;
         this.drone.y = 200;
         this.drone.name = "openworlddrone";
         var _loc2_:Sprite = O.getItem("candycane").updateGraphic();
         _loc2_.scaleX = 0.6;
         _loc2_.scaleY = 0.6;
         _loc2_.x = 20;
         _loc2_.y = -5;
         _loc2_.rotation = -90;
         this.drone.addChild(_loc2_);
         var _loc3_:Sprite = O.getItem("santahat").updateGraphic();
         _loc3_.scaleX = -1;
         _loc3_.x = -5;
         _loc3_.y = -18;
         this.drone.addChild(_loc3_);
         this.fader = new Sprite();
         this.fader.name = "openworldfader";
         this.fader.mouseEnabled = false;
         this.fader.graphics.beginFill(14149611);
         this.fader.graphics.drawRect(0,0,1280,720);
         var _loc4_:TextField = new TextField();
         _loc4_.name = "otf";
         _loc4_.defaultTextFormat = new TextFormat(Tweak.FONT,72);
         _loc4_.textColor = 16777215;
         _loc4_.wordWrap = true;
         _loc4_.multiline = true;
         _loc4_.selectable = false;
         _loc4_.mouseEnabled = false;
         _loc4_.width = GameState.width;
         _loc4_.height = GameState.height;
         _loc4_.text = "\n\nTHE\nNAUGHTY\nLIST";
         _loc4_.y = 30;
         _loc4_.filters = [new GlowFilter(1118481,1,2,2,4)];
         var _loc5_:TextFormat = _loc4_.getTextFormat();
         _loc5_.align = TextFormatAlign.CENTER;
         _loc4_.setTextFormat(_loc5_);
         this.fader.addChild(_loc4_);
         this.tf = new TextField();
         this.tf.name = "openworldtf";
         this.tf.defaultTextFormat = new TextFormat(Window.FONT,24,null,null,null,null,null,null,TextFormatAlign.RIGHT);
         this.tf.textColor = 16777215;
         this.tf.width = 600;
         this.tf.height = 200;
         this.tf.wordWrap = true;
         this.tf.multiline = true;
         this.tf.selectable = false;
         this.tf.mouseEnabled = false;
         this.tf.text = "Hello, world.";
         var _loc6_:TextFormat = this.tf.getTextFormat();
         _loc6_.align = TextFormatAlign.CENTER;
         this.tf.setTextFormat(_loc6_);
         this.tf.filters = [new GlowFilter(1118481,1,2,2,4)];
         Main.instance.stage.addChild(this.drone);
         Main.instance.stage.addChild(this.tf);
         Main.instance.stage.addChild(this.fader);
         this.animate();
         this.animaterotate();
         this.animatetext();
         this.animatefadein();
         this.spawnDoll();
      }
      
      public function spawnDoll() : *
      {
         if(this.spawning)
         {
            return;
         }
         this.spawning = true;
         GameState.ui.menuSpawn.close();
         var _loc1_:b2Body = Physics.world.GetBodyList();
         while(_loc1_)
         {
            userData(_loc1_.GetUserData()).resistDisintegrating = false;
            userData(_loc1_.GetUserData()).trigger = new Disintegrate("snow",50,10);
            userData(_loc1_.GetUserData()).triggered = true;
            _loc1_ = _loc1_.GetNext();
         }
         Main.instance.stopDragging(false);
         Tweener.addTween(this.tf,{
            "scaleX":0,
            "scaleY":0,
            "delay":1,
            "time":0.1,
            "transition":"easeInOutBounce",
            "onComplete":this.SpawnDollDelay
         });
      }
      
      private function SpawnDollDelay() : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:Vector.<Array> = null;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:int = 0;
         var _loc6_:b2Body = null;
         var _loc1_:b2Body = Physics.world.GetBodyList();
         while(_loc1_)
         {
            userData(_loc1_.GetUserData()).dead = true;
            _loc1_ = _loc1_.GetNext();
         }
         Properties.resetProperties();
         this.doll = [];
         for each(_loc2_ in GameState.objects.doll(600,400,0,1))
         {
            this.doll.push(_loc2_);
         }
         _loc3_ = new Vector.<Array>();
         _loc3_.push(["9b8360","932022"]);
         _loc3_.push(["59482b","f8e7e2"]);
         _loc3_.push(["47391f","f8e7e2"]);
         _loc3_.push(["666666","7c0e10"]);
         _loc4_ = GameState.objects.spawnSkin.slice();
         GameState.objects.spawnSkin = _loc3_;
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc6_ = GameState.objects.delayedSpawnObject("tradingcard",GameState.width * 0.1 + _loc5_ * 40,550,0,false,true,GameState.objects.spawnSkin);
            if(_loc6_)
            {
               TradingCard(userData(_loc6_.GetUserData()).trigger).ratios = [0.85,0.7,0.55,0.2];
               TradingCard(userData(_loc6_.GetUserData()).trigger).item = O.names[Math.random() * O.names.length >> 0];
               TradingCard(userData(_loc6_.GetUserData()).trigger).seed = Math.random() * 900000 >> 0;
               userData(_loc6_.GetUserData()).pfx = new PFXGlow(_loc6_,_loc6_.GetWorldCenter());
               userData(_loc6_.GetUserData()).pfx.attachParticles(1,"sparkle");
               userData(_loc6_.GetUserData()).unbreakable = true;
               userData(_loc6_.GetUserData()).ghost = true;
               userData(_loc6_.GetUserData()).resistEverything();
            }
            _loc5_++;
         }
         GameState.objects.spawnSkin = _loc4_;
         this.switchLine = true;
         this.animatetext();
         this.spawning = false;
      }
      
      override public function update() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         var _loc4_:userData = null;
         if(_particles)
         {
            _loc2_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc3_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            if(Math.random() > 0.5)
            {
               this.rain.addParticles(1,_loc2_,580,0,0,4,4);
            }
            if(Math.random() > 0.5)
            {
               _loc2_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
               this.rain2.addParticles(1,_loc2_,_loc3_,0,0,4,4);
            }
            if(Math.random() > 0.5)
            {
               _loc2_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
               this.rain2.addParticles(1,_loc2_,_loc3_,0,0,4,4);
            }
         }
         super.update();
         if(!this.init)
         {
            this.Init();
         }
         this.tf.x += (-this.tf.x + this.drone.x - 680) * 0.01;
         this.tf.y += (-this.tf.y + this.drone.y) * 0.01;
         if(this.tutorial != 0)
         {
            if(GameState.mouseDown && !this.skipped)
            {
               Tweener.removeTweens(this.tf);
               this.animatetext();
               this.skipped = true;
            }
            else if(!GameState.mouseDown)
            {
               this.skipped = false;
            }
         }
         var _loc1_:* = 0;
         while(_loc1_ < this.doll.length)
         {
            _loc4_ = userData(this.doll[_loc1_].GetUserData());
            if(_loc4_.dead || _loc4_.hasBeenCut || _loc4_.health < 10 || Joints.NumJoints(this.doll[_loc1_]) == 0)
            {
               this.doll.splice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
         if(this.doll.length <= 4)
         {
            this.spawnDoll();
         }
      }
      
      private function animate() : void
      {
         Tweener.addTween(this.drone,{
            "x":Math.random() * 50 + 820,
            "y":Math.random() * 100 + 200,
            "time":(0.6 + Math.random() * 1.2) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animate
         });
      }
      
      private function animaterotate() : void
      {
         Tweener.addTween(this.drone,{
            "rotation":Math.random() * 60 - 30,
            "delay":0.2 + Math.random() * 0.6,
            "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
            "transition":"easeInOutBounce",
            "onComplete":this.animaterotate
         });
      }
      
      private function animatetext() : void
      {
         try
         {
            if(this.switchLine)
            {
               this.tf.scaleX = 0.5;
               this.tf.scaleY = 0.5;
               Tweener.addTween(this.tf,{
                  "scaleX":1,
                  "scaleY":1,
                  "time":0.2,
                  "transition":"easeInBack"
               });
               this.switchLine = false;
               this.line = this.lines[int(Math.random() * this.lines.length)];
               this.line = this.line.replace("NAUGHTY",this.naughty[Math.random() * this.naughty.length >> 0]);
               this.line = this.line.replace("RANDOM",int(Math.random() * 9000 + 2).toString());
            }
            if(this.tutorial != 0)
            {
               this.line = this.tutoriallines[this.tutorial];
               ++this.tutorial;
               if(this.tutorial >= this.tutoriallines.length)
               {
                  this.tutorial = 0;
                  this.switchLine = true;
               }
            }
         }
         catch(e:Error)
         {
            line = "...";
         }
         this.tf.text = this.line;
         Tweener.addTween(this.tf,{
            "rotation":0,
            "delay":this.tf.text.length * 0.1 + 2,
            "time":1,
            "transition":"easeInBack",
            "onComplete":this.animatetext
         });
      }
      
      private function animatefadeout() : void
      {
         GameState.menuHandler.closeAll();
         Tweener.addTween(this.fader,{
            "alpha":0,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack"
         });
         this.tf.text = "";
      }
      
      private function animatefadein() : void
      {
         Tweener.addTween(this.fader,{
            "alpha":1,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animatefadeout
         });
      }
   }
}

