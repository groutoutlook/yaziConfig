-- Run user commands directly so their syntax is interpreted by the preferred shell.
local cwd = ya.sync(function()
	ya.emit("escape", { visual = true })
	return tostring(cx.active.current.cwd)
end)

local function shells()
	local override = os.getenv("YAZI_SHELL")
	if override and override ~= "" then return { override } end
	if ya.target_family() == "windows" then return { "pwsh", "powershell" } end
	local shell = os.getenv("SHELL")
	return { shell and shell ~= "" and shell or "/bin/sh" }
end

local function shell_args(shell, command)
	local name = shell:match("([^/\\]+)$"):lower():gsub("%.exe$", "")
	if name == "pwsh" or name == "powershell" then
		return command and { "-NoLogo", "-Command", command } or { "-NoLogo" }
	end
	if command then return { "-c", command } end
	return name == "nu" and {} or { "-i" }
end

-- Notifications contain plain text, so terminal escape sequences must not reach them.
local function plain_text(text)
	return (text
		:gsub("\27%][^\7\27]*\7", "")
		:gsub("\27%][^\7\27]*\27\\", "")
		:gsub("\27%[[0-?]*[ -/]*[@-~]", "")
		:gsub("\27[@-_]", "")
		:gsub("\r\n", "\n")
		:gsub("\r", "\n")
		:gsub("[%z\1-\8\11\12\14-\31\127]", ""))
end

return {
	entry = function(_, job)
		local interactive = job.args.interactive
		local block = interactive or job.args.block
		local command
		if not interactive then
			local value, event = ya.input {
				title = block and "Preferred shell (block):" or "Preferred shell:",
				pos = { "top-center", y = 2, w = 70 },
			}
			if event ~= 1 or not value or value == "" then return end
			command = value
		end

		local directory = cwd()
		local permit = block and ui.hide()
		local result, err
		for _, shell in ipairs(shells()) do
			local process = Command(shell):arg(shell_args(shell, command)):cwd(directory)
			if block then
				result, err = process:stdin(Command.INHERIT):stdout(Command.INHERIT):stderr(Command.INHERIT):status()
			else
				result, err = process
					:env("NO_COLOR", "1")
					:env("CLICOLOR", "0")
					:env("CLICOLOR_FORCE", "0")
					:env("FORCE_COLOR", "0")
					:env("TERM", "dumb")
					:output()
			end
			if result then break end
		end
		if permit then permit:drop() end

		if not result then
			ya.notify { title = "Preferred shell", content = plain_text(tostring(err)), level = "error", timeout = 8 }
		elseif not block then
			local output = plain_text((result.stdout or "") .. (result.stderr or ""))
			ya.notify {
				title = "Preferred shell",
				content = output ~= "" and output or ("Exit code: " .. tostring(result.status.code)),
				level = result.status.success and "info" or "error",
				timeout = 8,
			}
		elseif not result.success then
			ya.notify { title = "Preferred shell", content = "Exit code: " .. tostring(result.code), level = "error", timeout = 8 }
		end
	end,
}
