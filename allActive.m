function a = allActive(mousedata)

a.msn =  cat(2,mousedata.activationStateMSN, mousedata.actStateBroadMSN);
a.chi = cat(2,mousedata.activationStateCHI, mousedata.actStateBroadCHI);
a.fsi = cat(2,mousedata.activationStateFSI, mousedata.actStateBroadFSI);
end