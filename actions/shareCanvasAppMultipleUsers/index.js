const core = require('@actions/core');
const github = require('@actions/github');
const Shell = require('node-powershell');


try {
  const ps = new Shell({
    verbose: true,
    executionPolicy: 'Bypass',
    noProfile: true,
  });
  const environmentID = core.getInput('environmentID');
 
  const user = core.getInput('user');
 
  const pass = core.getInput('pass');
 
  const canvasAppID = core.getInput('canvasAppID');

  const role = core.getInput('role');

  const filePath = core.getInput('filePath');

  var s = concatenate(environmentID,user,pass,canvasAppID,role,filePath);

  console.log(`String ${s}`);

  ps.addCommand(s)
  ps.invoke().then(output => {
      console.log(output);
      ps.dispose();
    }).catch(err => {
      console.log(err);
      ps.dispose();
    });
  } catch (error) {
  core.setFailed(error.message);
}

function concatenate(environmentID,user,pass,canvasAppID,role,filePath){
  var str = "";
  var str = str.concat("D:\\a\\_actions\\Hitachi-PowerPlatform\\Hit-Power-Actions\\v1\\actions\\shareCanvasAppMultipleUsers\\sharecanvas.ps1 -environmentID " + environmentID);
  var str = str.concat(" -user " + user);
  var str = str.concat(" -pass " + pass);
  var str = str.concat(" -canvasAppID "+ canvasAppID);
  var str = str.concat(" -role " + role);
  var str = str.concat(" -filePath " + filePath);
  return str;
}