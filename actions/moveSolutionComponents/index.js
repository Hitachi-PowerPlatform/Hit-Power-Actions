const core = require('@actions/core');
const github = require('@actions/github');
const Shell = require('node-powershell');

try {
  const ps = new Shell({
    verbose: true,
    executionPolicy: 'Bypass',
    noProfile: true,
  });
  const sourceSolutionName = core.getInput('sourceSolutionName');
  const targetSolutionName = core.getInput('targetSolutionName');
  const targetCRMurl = core.getInput('targetCRMurl');
  userName = core.getInput('userName');
  userPassword = core.getInput('userPassword');
  clientId = core.getInput('clientId');
  clientSecret = core.getInput('clientSecret');
  const authType = core.getInput('authType');

  if(authType == 'ClientSecret'){
    userName = "user";
    userPassword = "pwd";
    var s = concatenate(sourceSolutionName,targetSolutionName,targetCRMurl,userName,userPassword,clientId,clientSecret,authType);
  }else {
    clientId = "id"
    clientSecret = "secret"
    var s = concatenate(sourceSolutionName,targetSolutionName,targetCRMurl,userName,userPassword,clientId,clientSecret,authType);
  }
  

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

function concatenate(sourceSolutionName,targetSolutionName,targetCRMurl,userName,userPassword,clientId,clientSecret,authType){
  var str = "";
  var str = str.concat("D:\\a\\_actions\\Hitachi-PowerPlatform\\Hit-Power-Actions\\v1\\actions\\moveSolutionComponents\\MoveComponents.ps1 -psSourceSolutionName " + sourceSolutionName);
  var str = str.concat(" -psTargetSolutionName " + targetSolutionName);
  var str = str.concat(" -psTargetCRMurl " + targetCRMurl);
  var str = str.concat(" -psCRMusername " + userName);
  var str = str.concat(" -psCRMpassword " + userPassword);
  var str = str.concat(" -psClientId " + clientId);
  var str = str.concat(" -psClientSecret " + clientSecret);
  var str = str.concat(" -psAuthType " + authType);
  return str;
}