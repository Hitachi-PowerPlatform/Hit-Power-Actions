const core = require('@actions/core');
const github = require('@actions/github');
const Shell = require('node-powershell');

try {
  const ps = new Shell({
    verbose: true,
    executionPolicy: 'Bypass',
    noProfile: true,
  });
  const flowid = core.getInput('flowid');
  const user = core.getInput('user');
  const pass = core.getInput('pass');
  const envName = core.getInput('envName');
 
  var s = concatenate(flowid,user,pass,envName);

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

function concatenate(flowid,user,pass,envName){
  var str = "";
  var str = str.concat("\.\\actions\\enableMultipleFlows\\enablemultipleflows.ps1 -flowid " + flowid);
  var str = str.concat(" -pass " + pass);
  var str = str.concat(" -user " + user);
  var str = str.concat(" -envName " + envName);
  return str;
}