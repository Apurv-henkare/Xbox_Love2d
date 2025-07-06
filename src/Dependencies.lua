Class = require 'lib/class'
push = require 'lib/push'
wf= require 'lib/windfield/windfield' 
cameraFile = require 'lib/hump/camera'
anim8 =require 'lib/anim8/anim8'
cam =cameraFile()

require 'src/constant'
require 'src/Player'

require 'src/states/StateStack'
require 'src/states/BaseState' 

require 'src/states/game/MainMenu'
require 'src/states/game/PlayState'
require 'src/states/game/Intro'
require 'src/states/game/Sage'
require 'src/states/game/Password'
