package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import shiny.PFXOutline;
   import triggers.Disintegrate;
   import triggers.Goop;
   
   public class PumpkinMoon extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var rain2:ParticleSystem;
      
      internal var spawner:Timer;
      
      internal var drones:Vector.<b2Body>;
      
      internal var pumpkins:Vector.<b2Body>;
      
      public var pumpkindoll:Array;
      
      private var tf:TextField;
      
      private var fader:Sprite;
      
      public var drone:Sprite;
      
      public var moon:Sprite;
      
      internal var healthbars:int;
      
      internal var dollbars:int;
      
      internal var edgepan:int;
      
      internal var dead:Boolean = false;
      
      internal var score:Number = 0;
      
      internal var gamespeed:Number = 1;
      
      internal var init:Boolean = false;
      
      internal var targetPumpkin:int = 2;
      
      internal var skipped:Boolean = false;
      
      internal var tutorial:int = -1;
      
      internal var tutoriallines:Array = ["Hello, person.","Hello, person.","Hello, person.","The devouring moon is risen!","The rain is coming...","CONTROLS"];
      
      internal var lines:Array = ["GIVE THEM THE GOOD STUFF!","NO MOON ROCKS ALLOWED!","SAY NO TO MOON CHEESE!","BACK IN ORBIT!","BACK IN SPACE!","GIT ON OUTTA HEER!","THESE OUR ARE PUMPKINS!","I\'M SO MAD I COULD SPIT!","GET ON BACK IN SPACE!","THERE\'S MORE OF \'EM\nTHAN I CAN COUNT!\nAT LEAST THREE.","IF IT BLEEDS WE CAN KICK IT!","IF IT BLEEDS WE CAN PUNCH IT!","IF IT BLEEDS WE CAN HEADBUTT IT!","I NEED WINDSHIELD WIPERS!","SPLURT!","SPLORT!","BONK THEM WITH THE BONKY END!","HAPPINESS IS A PROTECTED PUMPKIN!","SMILE, AND WAIT FOR THE SMASH.","GET OUTTA HEER!","GET ON OUTTA HEER!","SLASH \'EM!","SLASHER!","SPLAT!","SPLORGLE!","DING!","GOTTEM!","GOT \'EM!","GET \'EM!","GUT \'EM!","GIT \'EM!","SWING FASTER!","PUNCH FASTER!","DESTROY. THEM. ALL.","PROTECT THE PUMPKINS!","TURNS OUT THE MOON IS MADE OF DEATH","THIS IS NOT CHEESE","THIS AIN\'T CHEESE","WHERE IS THE CHEESE GRATER?","IS THIS CHEESE?","KICK THE MOONROCKS!","PUNCH THE MOONROCKS!","WHY DOES THE MOON HAVE TEETH!?","SHOULD\'VE BRUSHED YOUR TEETH."
      ,"KILL. THEM. ALL.","CARVE. THEM. ALL.","I\'LL CARVE YER FACE!","I\'LL CARVE YER FACE OFF!","NO SOLICITORS!","LOUD NOISES AND ANGRINESS!","HELLO. BYE.","NO MERCY!"];
      
      internal var pumpkinlost:Array = ["OH THE PUMPKINITY!","ANOTHER PUMPKIN FALLS!","DESTROY FASTER!","BECOME UMBRELLA!","PROTECT BETTER!","PROTECT FASTER!","PROTECT STRONGER!","NOOOOOOOOOOOOOOOOOOO!","IT\'S DESTROYING OUR PUMPKINS!","NOT THE PUMPKINS!","WHY WON\'T SOMEBODY THINK OF THE PUMPKINS!?","THEY\'VE BROKEN ANOTHER ONE!","ANOTHER PUMPKIN GONE!","PROTECT THE PUMPKINS!","SURELY THERE\'S AN END TO THIS MADNESS?","THIS IS HOPELESS","EVERYTHING WILL BURN","WE\'RE ALL GOING TO MELT!","THIS IS THE END!","SAVE THE PUMPKINS!","NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!","NOOOO! THE PUMPKINS!"];
      
      internal var deadlines:Array = ["You have failed.","You just single-handedly ruined everything.","Did you at any point try playing better?","Maybe you didn\'t fail miserably in some other universe.","I\'m sure you tried your very best.","Don\'t worry. We\'ll all just be killed.","I\'m sure they will just leave and not kill us all. Yeeeah.","Just so you know, there were only 42692390852365 pieces of debris left. You blocked approximately... 0.0001% of them.","It\'s not all bad. At least we\'ll know who to blame.","I mean, I had no expectations, and you still let me down.","Great job. At killing us all.","Great job. Not.","Press [Esc] to quit.","Press [Esc] to quit.","Press [Esc] to quit.","Press [Esc] to quit.","Well, at least you blocked\nALIENSCORE attacks.","Well, at least you deflected\nALIENSCORE attacks.","Well, blocking ALIENSCORE attacks is\nbetter than nothing.","Well, deflecting ALIENSCORE attacks is\nbetter than nothing.","You protected the pumpkins from ALIENSCORE attacks.","You blocked ALIENSCORE attacks."
      ,"You deflected ALIENSCORE attacks.","ALIENSCORE pieces of debris went splurt.","ALIENSCORE pieces of debris went splat.","ALIENSCORE pieces of moon went splat.","ALIENSCORE moonrocks went splat.","ALIENSCORE moonrocks went splurt.","ALIENSCORE attacks blocked, a few hundred billion left.","Only ALIENSCORE attacks blocked? Could\'ve been a million.","Just so you know, this game has no win condition, and I\'m being overly antagonistic to evoke an emotional response.","If only this game had a win condition and not just disappointment."];
      
      internal var pumpkincount:int = 15;
      
      public function PumpkinMoon()
      {
         Main.instance.stage.focus = null;
         Main.instance.reset(false,false);
         this.drones = new Vector.<b2Body>();
         super(GameState.width,GameState.height);
         enableClutter = false;
         enableFiller = false;
         enableParticles = false;
         enableSeed = false;
         _name = "pumpkinmoon";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _backgroundColour = 1249031;
         _wallColour = 2365454;
         spawnX = 2000;
         _background = new BitmapData(1600,600,false,2499106);
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_dustmoon"));
         this.rain2 = new ParticleSystem("rain2",_width,_height,R.getSprite("p_dustmoon"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 1;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 10;
         this.rain.particleHealth = 1000;
         this.rain.particleWander = 0.2;
         this.rain2.useWorldGravity = false;
         this.rain2.particleFade = 1;
         this.rain2.particleFadeRandom = 10;
         this.rain2.particleHealth = 1000;
         this.rain2.particleRestitution = 0.5;
         this.rain2.particleFriction = 0.9;
         this.rain2.particleWander = 0.4;
         this.rain2.particleCollide = false;
         _particleSystems.push(this.rain);
         _particleSystems.push(this.rain2);
         _borderLeft = -2000;
         _borderRight = 3000;
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _floor = true;
         _loop = false;
         wallThickness = 16;
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
         Main.instance.loadedLevel = "";
         Main.instance.currentSave = "";
         GameState.roleplaying = false;
         Main.instance.reset();
      }
      
      private function removeGraphics() : void
      {
         var _loc1_:DisplayObject = Main.instance.stage.getChildByName("openworlddrone");
         var _loc2_:DisplayObject = Main.instance.stage.getChildByName("openworldmoon");
         var _loc3_:DisplayObject = Main.instance.stage.getChildByName("openworldtf");
         var _loc4_:DisplayObject = Main.instance.stage.getChildByName("openworldfader");
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
         if(_loc4_)
         {
            Main.instance.stage.removeChild(_loc4_);
         }
         sounds.stop("halloweenmusic");
      }
      
      public function Init() : *
      {
         var _loc3_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:b2Body = null;
         var _loc7_:Sprite = null;
         var _loc8_:TextField = null;
         var _loc9_:TextFormat = null;
         var _loc10_:TextFormat = null;
         this.init = true;
         Main.instance.reset(false,true);
         var _loc1_:* = "mutilate=2;walls=442c18;wallR=false;wallL=false;roof=false;particles=true;camera=300,0,0.75;loop=false;filler=false;autowind=false;seed=42;clutter=100;gravity=20;wind=0;temperature=37;breakalive=1,breakjoints=1,breakobjects=1,contacts=1|NM=makeshiftpipespear,PX=-16.67,PY=491.00,AN=-34.00,DN=0,TM=37,LR=0;NM=makeshiftpipespear,PX=1086.00,PY=491.33,AN=40.00,DN=0,TM=37,LR=0;NM=residentialfencepost,PX=1102.00,PY=515.33,AN=50.00,DN=0,TM=37,LR=0;NM=residentialfencepost,PX=-39.67,PY=526.00,AN=-53.00,SZ=0.95,DN=0,TM=37,LR=0;NM=residentialfencesegment,PX=314.38,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=makeshiftpipespear,PX=1138.00,PY=545.33,AN=70.00,DN=0,TM=37,LR=0;NM=makeshiftpipespear,PX=-72.67,PY=547.00,AN=-70.00,DN=0,TM=37,LR=0;NM=residentialfencesegment,PX=142.00,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=227.67,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=658.49,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=401.78,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=486.11,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=571.78,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=745.23,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=829.58,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=915.25,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=57.67,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencesegment,PX=1001.96,PY=539.82,DN=0,TM=37,LR=0,ghost=1;NM=residentialfencepost,PX=1053.00,PY=479.33,SZ=1.1663507799970827,DN=0,TM=37,LR=0;NM=residentialfencepost,PX=9.33,PY=482.00,SZ=1.166350779997083,DN=0,TM=37,LR=0|||ID=0,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=1,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=2,SKIN=7444334A2B20.7259513B2620;ID=3,SKIN=7444334A2B20.7259513B2620;ID=4,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=5,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=6,SKIN=BAB0833C3C3C.3D312A3A281E.3F36303D2F26.433529422C1B;ID=7,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=8,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=9,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=10,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=11,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=12,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=13,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=14,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=15,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=16,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=17,SKIN=511E083B1D05.7259513B2E2A.7444333B221A;ID=18,SKIN=744433573023.7259514B2F27;ID=19,SKIN=744433573023.7259514B2F27||||";
         IO.loadWorld(_loc1_,true);
         _borderLeft = -2000;
         _borderRight = 3000;
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
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
         Main.instance.cam.scaleX = Main.instance.cam.scaleY = 0.7;
         Main.instance.cam.x = 200;
         Main.instance.cam.y = 180;
         this.score = 0;
         Tool.drag();
         this.pumpkins = new Vector.<b2Body>();
         var _loc2_:Number = 80;
         var _loc4_:Array = [0.5,0.6,0.7,0.8,0.9,1,0.9,0.8,0.7,0.6,0.5];
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc3_ = GameState.objects.spawnItem(O.getItem("pumpkin").vertices,[1],2 * O.getItem("pumpkin").scale * _loc4_[_loc5_],"pumpkin",_loc2_ + _loc5_ * 90,-580,0,O.getItem("pumpkin").colours);
            userData(_loc3_.GetUserData()).layer = 2;
            userData(_loc3_.GetUserData()).locked = true;
            userData(_loc3_.GetUserData()).alive = true;
            userData(_loc3_.GetUserData()).layer = 2;
            userData(_loc3_.GetUserData()).health = _loc4_[_loc5_] * 300;
            userData(_loc3_.GetUserData()).maxhealth = userData(_loc3_.GetUserData()).health;
            userData(_loc3_.GetUserData()).bloodColour = 16742694;
            GraphicUtils.addGraphicToLayer(_loc3_.GetUserData());
            this.pumpkins.push(_loc3_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.pumpkins[_loc5_].SetXForm(new b2Vec2((_loc2_ + _loc5_ * 90) / Physics.scale,575 / Physics.scale),0);
            _loc5_++;
         }
         this.pumpkindoll = GameState.objects.doll(GameState.width * 0.5,450,0,1);
         for each(_loc6_ in this.pumpkindoll)
         {
            userData(_loc6_.GetUserData()).ignore = "pumpkin";
            userData(_loc6_.GetUserData()).resistCutting = true;
            userData(_loc6_.GetUserData()).resistAliveBreak = true;
            userData(_loc6_.GetUserData()).unbreakable = true;
            userData(_loc6_.GetUserData()).health = 99999999999;
            userData(_loc6_.GetUserData()).pfx = new PFXOutline(_loc6_,_loc6_.GetWorldCenter());
            userData(_loc6_.GetUserData()).pfx.attachParticles(1,"blood");
            userData(_loc6_.GetUserData()).pfx.amount = 0.1;
            _loc6_.PutToSleep();
         }
         this.tutorial = 1;
         this.moon = O.getItem("crescentmoonglow").updateGraphic();
         this.moon.scaleX = this.moon.scaleY = 0.1;
         this.moon.x = 6600;
         this.moon.y = -5000;
         this.moon.name = "openworldmoon";
         this.moon.mouseEnabled = false;
         this.drone = O.getItem("dronespeaker").updateGraphic();
         this.drone.x = 200;
         this.drone.y = 200;
         this.drone.name = "openworlddrone";
         this.drone.mouseEnabled = false;
         _loc7_ = O.getItem("tinyumbrella").updateGraphic();
         _loc7_.scaleX = 1.5;
         _loc7_.scaleY = 1.5;
         _loc7_.x = 4;
         _loc7_.y = -24;
         _loc7_.rotation = -24;
         this.drone.addChild(_loc7_);
         this.fader = new Sprite();
         this.fader.name = "openworldfader";
         this.fader.mouseEnabled = false;
         this.fader.graphics.beginFill(0);
         this.fader.graphics.drawRect(0,0,1280,720);
         _loc8_ = new TextField();
         _loc8_.name = "otf";
         _loc8_.defaultTextFormat = new TextFormat(Tweak.FONT,72);
         _loc8_.textColor = 11511945;
         _loc8_.wordWrap = true;
         _loc8_.multiline = true;
         _loc8_.selectable = false;
         _loc8_.mouseEnabled = false;
         _loc8_.width = GameState.width;
         _loc8_.height = GameState.height;
         _loc8_.text = "\nDEVOURING MOON";
         _loc8_.y = 160;
         _loc9_ = _loc8_.getTextFormat();
         _loc9_.align = TextFormatAlign.CENTER;
         _loc8_.setTextFormat(_loc9_);
         this.fader.addChild(_loc8_);
         this.tf = new TextField();
         this.tf.name = "openworldtf";
         this.tf.defaultTextFormat = new TextFormat(Window.FONT,24);
         this.tf.textColor = 16777164;
         this.tf.width = 450;
         this.tf.height = 200;
         this.tf.wordWrap = true;
         this.tf.multiline = true;
         this.tf.selectable = false;
         this.tf.mouseEnabled = false;
         this.tf.text = "Hello, world.";
         _loc10_ = this.tf.getTextFormat();
         _loc10_.align = TextFormatAlign.CENTER;
         this.tf.setTextFormat(_loc10_);
         this.tf.filters = [new GlowFilter(1118481,1,2,2,4)];
         Main.instance.stage.addChild(this.moon);
         Main.instance.stage.addChild(this.drone);
         Main.instance.stage.addChild(this.tf);
         Main.instance.stage.addChild(this.fader);
         this.animate();
         this.animaterotate();
         this.animatetext();
         this.animatefadein();
         this.spawner = new Timer(3000);
         this.spawner.addEventListener(TimerEvent.TIMER,this.spawn);
         this.spawner.start();
      }
      
      override public function update() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:* = 0;
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         var _loc6_:b2Body = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         var _loc10_:b2Vec2 = null;
         var _loc11_:int = 0;
         if(_particles && this.tutorial == 0)
         {
            _loc4_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc5_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            if(Math.random() > 0.9)
            {
               this.rain.addParticles(1,_loc4_,_loc5_,0,0,4,4);
            }
            if(Math.random() > 0.9)
            {
               _loc4_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
               this.rain2.addParticles(1,_loc4_,_loc5_,0,0,4,4);
            }
         }
         super.update();
         if(!this.init)
         {
            this.Init();
         }
         this.tf.x += (-this.tf.x + this.drone.x + 50) * 0.01;
         this.tf.y += (-this.tf.y + this.drone.y - 25) * 0.01;
         if(this.dead)
         {
            return;
         }
         if(this.pumpkins.length == 0)
         {
            for each(_loc6_ in this.pumpkins)
            {
               Body.Disintegrate(_loc6_,"inherit",100,10,10);
            }
            this.dead = true;
            _loc7_ = "You blocked ALIENSCORE attacks before perishing. Press [Esc] to quit.";
            _loc7_ = _loc7_.replace("ALIENSCORE",this.score.toString());
            this.tf.text = _loc7_;
            _loc8_ = ["explosive","fire2","fire3","explosive","fire2","fire3","bigSmoke","smoke","shock","slice"];
            _loc9_ = 1000;
            _loc10_ = this.pumpkindoll[0].GetWorldCenter().Copy();
            _loc10_.Multiply(Physics.scale);
            _loc11_ = 0;
            while(_loc11_ < _loc9_)
            {
               GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc8_[Math.random() * _loc8_.length >> 0],0,0,Math.random() * 100,Math.random() * 100);
               _loc11_++;
            }
            for each(_loc1_ in this.pumpkindoll)
            {
               userData(_loc1_.GetUserData()).trigger = new Disintegrate("fire",50 + Math.random() * 50,1 + Math.random());
               userData(_loc1_.GetUserData()).triggered = true;
            }
            Tweener.removeAllTweens();
            Tweener.addTween(this.moon,{
               "scaleX":5,
               "scaleY":5,
               "delay":2.2,
               "time":2,
               "transition":"easeInBack"
            });
            Tweener.addTween(this.moon,{
               "rotation":0,
               "time":1,
               "transition":"easeInOutBounce"
            });
            Tweener.addTween(this.moon,{
               "x":666,
               "y":this.moon.y,
               "time":1,
               "transition":"easeInOutBounce"
            });
            return;
         }
         for each(_loc1_ in this.pumpkindoll)
         {
            if(_loc1_.GetPosition().y * Physics.scale > 800)
            {
               _loc1_.SetXForm(new b2Vec2(400 / Physics.scale,400 / Physics.scale),0);
            }
         }
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
         _loc2_ = 0;
         while(_loc2_ < this.pumpkins.length)
         {
            if(userData(this.pumpkins[_loc2_].GetUserData()).dead)
            {
               this.pumpkins.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.drones.length)
         {
            if(userData(this.drones[_loc2_].GetUserData()).dead)
            {
               this.drones.splice(_loc2_,1);
               _loc2_--;
               ++this.score;
            }
            _loc2_++;
         }
         var _loc3_:b2Body = Physics.world.GetBodyList();
         while(_loc3_)
         {
            if(userData(_loc3_.GetUserData()).hasBeenCut)
            {
               userData(_loc3_.GetUserData()).trigger = new Disintegrate("blood",50,10);
               userData(_loc3_.GetUserData()).triggered = true;
            }
            _loc3_ = _loc3_.GetNext();
         }
      }
      
      public function spawn(param1:TimerEvent) : void
      {
         var _loc4_:b2Body = null;
         if(this.tutorial != 0)
         {
            return;
         }
         if(this.pumpkincount == 0)
         {
            return;
         }
         if(this.drones.length > 30)
         {
            Body.Disintegrate(this.drones[0],"inherit",100,10,10);
            return;
         }
         var _loc2_:Vector.<Array> = new Vector.<Array>();
         _loc2_.push(["07a7c4","C19100"]);
         _loc2_.push(["b5b5b5","bb5b1b"]);
         _loc2_.push(["616161","3D2B19"]);
         _loc2_.push(["424242","202020"]);
         GameState.objects.spawnSkin = _loc2_;
         var _loc3_:Boolean = Math.random() > 0.5;
         Vars.objFriction = 999;
         Vars.objSize = Math.min(2.5,Math.random() * Math.random() * this.gamespeed / 200) + 1;
         var _loc5_:Number = Math.random() * 100;
         var _loc6_:Number = 400 + Math.random() * 400;
         var _loc7_:Number = -1000 - Math.random() * 250;
         if(_loc5_ > 90 && this.gamespeed > 500)
         {
            _loc4_ = GameState.objects.delayedSpawnObject("crescentbeam",_loc6_,_loc7_,0,!_loc3_,true,_loc2_);
         }
         else if(_loc5_ > 80)
         {
            _loc4_ = GameState.objects.delayedSpawnObject("crescentdrip",_loc6_,_loc7_,0,!_loc3_,true,_loc2_);
         }
         else if(_loc5_ > 60)
         {
            _loc4_ = GameState.objects.delayedSpawnObject("crescenttooth",_loc6_,_loc7_,0,!_loc3_,true,_loc2_);
         }
         else
         {
            _loc4_ = GameState.objects.delayedSpawnObject("crescenttear",_loc6_,_loc7_,0,!_loc3_,true,_loc2_);
         }
         var _loc8_:b2Vec2 = new b2Vec2(this.moon.x + Math.random() * 200 - 150,this.moon.y - 50 - Math.random() * 100);
         _loc8_.Multiply(1 / Physics.scale);
         _loc4_.SetXForm(_loc8_,Vars.toRadians * this.moon.rotation);
         var _loc9_:b2Vec2 = new b2Vec2(-Math.sin(Vars.toRadians * this.moon.rotation),Math.cos(Vars.toRadians * this.moon.rotation));
         _loc9_.Multiply(0.8 + 0.018 * this.gamespeed);
         _loc9_.Multiply(_loc4_.GetMass());
         _loc4_.ApplyImpulse(_loc9_,_loc4_.GetWorldCenter());
         var _loc10_:userData = userData(_loc4_.GetUserData());
         _loc10_.alive = true;
         _loc10_.ignore = "projectiles";
         _loc10_.maxhealth = 1;
         _loc10_.health = 1;
         _loc10_.bloodColour = 11511945;
         _loc10_.trigger = new Goop();
         _loc10_.triggered = true;
         _loc10_.ultrasharp = true;
         _loc10_.triggerForce = 50;
         _loc10_.triggerColour = "972d6f";
         _loc10_.sticky = true;
         _loc10_.sharp = true;
         _loc10_.projectile = true;
         _loc10_.triggerForce = Math.min(200,Math.random() * 30 + 20 + this.gamespeed / 200);
         _loc10_.triggerDuration = Math.max((Math.random() * 15 + 15) / (this.gamespeed / 1000),5);
         _loc10_.triggered = true;
         Vars.objFriction = 0.1;
         Vars.objSize = 1;
         GameState.objects.spawnSkin = new Vector.<Array>();
         this.drones.push(_loc4_);
         this.gamespeed += 50;
         this.gamespeed *= 1.005;
         if(this.spawner.delay > 500)
         {
            this.spawner.delay -= 60;
         }
         if(Math.random() > 0.9)
         {
            this.spawn(param1);
         }
      }
      
      private function animate() : void
      {
         if(this.pumpkincount == 0)
         {
            return;
         }
         Tweener.addTween(this.drone,{
            "x":Math.random() * 100 + 100,
            "y":Math.random() * 100 + 100,
            "time":(0.4 + Math.random() * 0.8) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animate
         });
         var _loc1_:Number = Math.random() * 200 - 800;
         _loc1_ += Math.min(800,this.gamespeed * 0.25);
         var _loc2_:Number = (0.6 + Math.random() * 1.2) / TimeLord.timerSpeed;
         _loc2_ *= Math.max(0.2,1 - this.gamespeed * 0.001);
         var _loc3_:Number = (0.6 + Math.random() * 1.2) / TimeLord.timerSpeed;
         _loc3_ *= Math.max(0.4,1 - this.gamespeed * 0.0001);
         if(this.tutorial != 0)
         {
            _loc2_ = 1;
            _loc3_ = 1;
         }
         Tweener.addTween(this.moon,{
            "x":Math.random() * 650 + 200,
            "y":_loc1_,
            "delay":_loc2_,
            "time":_loc3_,
            "transition":"easeInBack",
            "onComplete":this.animate
         });
         var _loc4_:Number = Math.max(1,3 - this.gamespeed * 0.0008);
         Tweener.addTween(this.moon,{
            "scaleX":_loc4_,
            "scaleY":_loc4_,
            "time":(0.6 + Math.random() * 1.2) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animate
         });
      }
      
      private function animaterotate() : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         Tweener.addTween(this.drone,{
            "rotation":Math.random() * 60 - 30,
            "delay":0.2 + Math.random() * 0.6,
            "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
            "transition":"easeInOutBounce",
            "onComplete":this.animaterotate
         });
         if(this.pumpkincount == 0)
         {
            return;
         }
         var _loc1_:* = Math.random() * 40 - 20;
         if(Math.random() > 1 - this.gamespeed * 0.001)
         {
            this.targetPumpkin = int(this.pumpkins.length * Math.random());
            _loc4_ = new b2Vec2(this.moon.x,this.moon.y + 1);
            _loc5_ = new b2Vec2(this.moon.x,this.moon.y);
            if(this.pumpkins.length > this.targetPumpkin)
            {
               _loc4_ = this.pumpkins[this.targetPumpkin].GetPosition().Copy();
               _loc4_.Multiply(Physics.scale);
            }
            _loc6_ = _loc4_.x - _loc5_.x;
            _loc7_ = _loc4_.y - _loc5_.y;
            _loc1_ = Math.atan2(_loc7_,_loc6_) * Vars.toDegrees - 90;
         }
         var _loc2_:Number = 0.4 + Math.random() * 0.8;
         _loc2_ *= Math.max(0.2,1 - this.gamespeed * 0.001);
         var _loc3_:Number = (0.6 + Math.random() * 0.6) / TimeLord.timerSpeed;
         _loc3_ *= Math.max(0.4,1 - this.gamespeed * 0.0001);
         Tweener.addTween(this.moon,{
            "rotation":_loc1_,
            "delay":_loc2_,
            "time":_loc3_,
            "transition":"easeInOutBounce",
            "onComplete":this.animaterotate
         });
      }
      
      private function animatetext() : void
      {
         var line:String = null;
         try
         {
            line = this.lines[int(Math.random() * this.lines.length)];
            if(this.pumpkincount > this.pumpkins.length)
            {
               line = this.pumpkinlost[int(Math.random() * this.pumpkinlost.length)];
               this.pumpkincount = this.pumpkins.length;
            }
            if(this.dead)
            {
               line = this.deadlines[int(Math.random() * this.deadlines.length)];
               line = line.replace("ALIENSCORE",this.score.toString());
               if(this.drones.length > 10)
               {
                  this.spawner.stop();
               }
            }
            if(this.tutorial != 0)
            {
               line = this.tutoriallines[this.tutorial];
               ++this.tutorial;
               line = line.replace("CONTROLS","Protect the pumpkins!\nBlock the attacks with the doll!");
               if(this.tutorial >= this.tutoriallines.length)
               {
                  this.tutorial = 0;
               }
            }
         }
         catch(e:Error)
         {
            line = "...";
         }
         this.tf.text = line;
         this.tf.scaleX = 1;
         this.tf.scaleY = 1;
         Tweener.addTween(this.tf,{
            "scaleX":0.5,
            "scaleY":0.5,
            "delay":this.tf.text.length * 0.1 + 1,
            "time":0.2 / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animatetext
         });
      }
      
      private function animatefadeout() : void
      {
         GameState.menuHandler.closeAll();
         if(!sounds.isPlaying("halloweenmusic"))
         {
            sounds.play("halloweenmusic",null,null,2,true,9000);
         }
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

