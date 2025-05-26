require("session"):setup {
	sync_yanked = true,
}
require("custom-shell"):setup({
    history_path = "default",
    save_history = true,
})
require("git"):setup()
