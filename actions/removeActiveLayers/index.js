const core = require('@actions/core');
const github = require('@actions/github');
const Shell = require('node-powershell');


try {
  const ps = new Shell({
    verbose: true,
    executionPolicy: 'Bypass',
    noProfile: true,
  });
  const tenantId = core.getInput('tenantId');
 
  const clientID = core.getInput('clientId');
 
  const clientSecret = core.getInput('clientSecret');
 
  const environmentUrl = core.getInput('environmentUrl');

  const filter = core.getInput('filter');

  var s = concatenate(tenantId,clientID,clientSecret,environmentUrl,filter);

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

function concatenate(tenantId,clientID,clientSecret,environmentUrl,filter){
  var str = "";
  var str = str.concat("D:\\a\\_actions\\Hitachi-PowerPlatform\\Hit-Power-Actions\\v1\\actions\\removeActiveLayers\\RemoveLayer.ps1 -psTenantId " + tenantId);
  var str = str.concat(" -psClientId " + clientID);
  var str = str.concat(" -psClientSecret " + clientSecret);
  var str = str.concat(" -psEnvironmentUrl "+ environmentUrl);
  var str = str.concat(" -psFilter " + filter);
  return str;
}