// UMU@2009/11/11 ����

// monitor_process.js

var strCScript = WScript.Path + "\\cscript.exe";
if (WScript.FullName != strCScript) {
	new ActiveXObject("WScript.Shell").Run(strCScript + " \"" + WScript.ScriptFullName + "\" //Nologo");
	WScript.Quit(-1);
}

var objWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\\\.\\root\\cimv2");
var ps = objWMI.ExecNotificationQuery("select * from __instancecreationevent within 1 where TargetInstance isa 'Win32_Process'");

var swdt = new ActiveXObject("WbemScripting.SWbemDateTime");

WScript.Echo("monitor_process.js by UMU @ 2009-03-16");
WScript.Echo("Press Ctrl+C to quit");
WScript.Echo("���ӽ��̴���ӥ����");
WScript.Echo("");
for (; ;) {
	var p = ps.NextEvent();

	try {
		swdt.Value = p.TargetInstance.CreationDate;
		WScript.StdOut.WriteLine(swdt.GetVarDate());
		WScript.StdOut.WriteLine('$' + p.TargetInstance.SessionId + ' [' + p.TargetInstance.ProcessId + '] ' + p.TargetInstance.Name);
		// WScript.StdOut.WriteLine('[' + swdt.GetVarDate() + '] $' + p.TargetInstance.SessionId + ' [' + p.TargetInstance.ProcessId + '] ' + p.TargetInstance.Name);
		WScript.StdOut.WriteLine(p.TargetInstance.ExecutablePath);
		WScript.StdOut.WriteLine(p.TargetInstance.CommandLine);
	}
	catch (ex) {
		WScript.StdOut.WriteLine(ex);
	}
	WScript.StdOut.WriteLine("");
}

delete ps;
delete objWMI;
delete swdt;
