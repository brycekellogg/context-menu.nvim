--   NeoTree:
--      - Add file
--      - Unstage file
--      - Diff file


-- ???
--
local function CopyPath()
    local state = require("neo-tree.sources.manager").get_state_for_window()
    local path = state.tree:get_node().path
    vim.fn.setreg('+', path)
end


-- ??
--
local function GitAdd()
    local state = require("neo-tree.sources.manager").get_state_for_window()
    require("neo-tree.sources.common.commands").git_add_file(state)
end


-- ??
--
local function GitUnstage()
    local state = require("neo-tree.sources.manager").get_state_for_window()
    require("neo-tree.sources.common.commands").git_unstage_file(state)
end


-- ??
return {
    items = {

        -- ???
        ['neotree-git-add'] = {
            display = "Neotree: Git Add File",
            enable = function ()
                return true
            end,
            action = GitAdd,
        },

        -- ???
        ['neotree-git-unstage'] = {
            display = "Neotree: Git Unstage File",
            enable = true,
            action = GitUnstage,
        },

        -- ???
        ['neotree-copy-path'] = {
            display = "Neotree: Copy Path",
            enable = function ()
                return true
            end,
            action = CopyPath,
        },
    },
}
