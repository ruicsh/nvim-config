local env_shell = vim.fn.env_get("SHELL")

local options = {}

if env_shell == "powershell" then -- Windows PowerShell
	-- `:h shell-powershell`
	options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}
elseif env_shell == "cmd" then -- Windows Command Prompt
	options = {
		shell = "C:\\Windows\\System32\\cmd.exe",
		shellcmdflag = "/c",
		shellredir = ">%s 2>&1",
		shellpipe = "2>&1 | tee %s",
		shellquote = '"',
		shellxquote = "",
	}
end

for option, value in pairs(options) do
	vim.opt[option] = value
end
