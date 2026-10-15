require("git"):setup()
require("zoxide"):setup {
	update_db = true,
}
-- -- Windows-specific bookmarks
-- if ya.target_family() == "windows" then
--   local home_path = os.getenv("USERPROFILE")
--   table.insert(bookmarks, {
--     tag = "Scoop Local",
--     path = os.getenv("SCOOP") or (home_path .. "\\scoop"),
--     key = "p"
--   })
--   table.insert(bookmarks, {
--     tag = "Scoop Global",
--     path = os.getenv("SCOOP_GLOBAL") or "C:\\ProgramData\\scoop",
--     key = "P"
--   })
-- end

