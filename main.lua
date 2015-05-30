---
---
display.setDefault('anchorX', 0)
display.setDefault('anchorY', 0)
display.setStatusBar(display.HiddenStatusBar)


storyboard = require("storyboard");
storyboard.gotoScene("menuScene");

storyboard.purgeOnSceneChange = true;
